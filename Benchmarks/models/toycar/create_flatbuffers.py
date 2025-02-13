import numpy as np
import tensorflow as tf #Need version 2.15, tflite converter has problems on >=2.16
import keras
from pathlib import Path
import subprocess, sys
import struct

from tqdm import tqdm

import librosa
import librosa.core
import librosa.feature
import sys
from tensorflow.python.ops import math_ops




cwd = str(Path.cwd())


#################
#load original trained model
#################
model = keras.models.load_model(cwd + "/models/ad01.h5") 





#########################
#load test data 
#########################
#For toycar, data is a .wav file.  need to convert to spectrogram.  Code and settings taken from https://github.com/mlcommons/tiny/blob/master/benchmark/training/anomaly_detection/convert_dataset.py    
                                     
# 01 calculate the number of dimensions
dims = 128 * 5

# 02 generate melspectrogram
y, sr = librosa.load(cwd + "/data/normal_id_01_00000000.wav", sr=None, mono=False)

# 02a generate melspectrogram using librosa
mel_spectrogram = librosa.feature.melspectrogram(y=y,
                                                 sr=sr,
                                                 n_fft=1024,
                                                 hop_length=512,
                                                 n_mels=128,
                                                 power=2.0) #frames==5

# 03 convert melspectrogram to log mel energy
log_mel_spectrogram = 20.0 / 2.0 * np.log10(mel_spectrogram + sys.float_info.epsilon)

# 3b take central part only
log_mel_spectrogram = log_mel_spectrogram[:,50:250];

# 04 calculate total vector size
vector_array_size = len(log_mel_spectrogram[0, :]) - 5 + 1

# 06 generate feature vectors by concatenating multiframes
vector_array = np.zeros((vector_array_size, dims))
for t in range(5):
    vector_array[:, 128 * t: 128 * (t + 1)] = log_mel_spectrogram[:, t: t + vector_array_size].T

# 08 (optional) save bin
#save_path = cwd + "/data/sample_0_ID_01" + ".bin"
# transpose to obtain correct order
#np.swapaxes(log_mel_spectrogram, 0, 1).astype('float32').tofile(save_path)

data = vector_array










#######################
# Run a forward pass of original model
#######################
model.summary()

pred = model.predict(data)

error = np.mean(np.square(data - pred)) #this is the output based on what our toycar C program does

print("Result Error - Original Model: ")
print(error)


errors = np.mean(np.square(data - pred), axis=1) #This is the output reported in the benchmarks
y_pred = np.mean(errors)
print("MLTinyPerf Error Calc method:")
print(y_pred)











#####################
# Folding Batch Norm Layers
####################
# folding BatchNormalization layers into Dense layers
# based on https://github.com/tensorflow/model-optimization/blob/master/tensorflow_model_optimization/python/core/quantization/keras/layers/conv_batchnorm.py
h = model.input
skip = False
for i in range(len(model.layers)):
    if skip:
        skip = False
        continue
    if isinstance(model.layers[i], keras.layers.Dense):
        if i < len(model.layers)-1 and isinstance(model.layers[i+1], keras.layers.BatchNormalization):
            kernel, bias = model.layers[i].get_weights()
            gamma, beta, moving_mean, moving_variance = model.layers[i+1].get_weights()

            folded_kernel_multiplier = gamma * math_ops.rsqrt(
                moving_variance + model.layers[i+1].epsilon)
            folded_kernel = math_ops.mul(
                folded_kernel_multiplier, kernel, name='folded_kernel')

            folded_bias = math_ops.subtract(
                beta,
                moving_mean * folded_kernel_multiplier,
                name='folded_bias')

            model.layers[i].set_weights([folded_kernel, folded_bias])
            skip = True
    print("i = " + str(i))
    print("h = " + str(h))
    h = model.layers[i](h)
model = keras.Model(inputs=model.input, outputs=h)
model.summary()



#######################
# Make FP32 tflite model
#######################

#converter = tf.lite.TFLiteConverter.from_keras_model(model)
#tflite_model = converter.convert()

#tflite_file = cwd + "/models/toycar_fp32.tflite"
#with tf.io.gfile.GFile(tflite_file, 'wb') as f:
#    f.write(tflite_model)
   
   
   
   
         
#######################
# Make INT8 tflite model
####################### 
#converter = tf.lite.TFLiteConverter.from_keras_model(model)
# Function to Generate Input data for INT8 model (needed for full int quantization)
#def representative_dataset_gen():
#    for sample in data[::5]:
#        sample = np.expand_dims(sample.astype(np.float32), axis=0)
#        yield [sample]
        
#converter.optimizations = [tf.lite.Optimize.DEFAULT]
#converter.representative_dataset = representative_dataset_gen
#converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
#converter.inference_input_type = tf.int8  # or tf.uint8
#converter.inference_output_type = tf.int8  # or tf.uint8
#tflite_model = converter.convert()
#tflite_file = cwd + "/models/toycar_int8.tflite"
#with tf.io.gfile.GFile(tflite_file, 'wb') as f:
#    f.write(tflite_model)
    
    
    
    
#######################
# Make FP16 tflite model
####################### 

# Function to Generate Input data for INT8 model (needed for full int quantization)
converter = tf.lite.TFLiteConverter.from_keras_model(model)   

converter.experimental_enable_resource_variables = True   
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS,
    #tf.lite.OpsSet.SELECT_TF_OPS //TODO: Cant use this (or delegates) for TFLM, can i use tflite instead?
]
converter.target_spec.supported_types = [tf.float16]

#converter.inference_input_type = tf.float16
#converter.inference_output_type = tf.float16 
tflite_model = converter.convert()

tflite_file = cwd + "/models/toycar_fp16.tflite"
with tf.io.gfile.GFile(tflite_file, 'wb') as f:
    f.write(tflite_model)
    
    
    
    
    
    
    
    
    
    
   
     
#####################
#Test FP32 tflite model
#####################

tflite_file = cwd + "/models/toycar_fp32.tflite"
interpreter = tf.lite.Interpreter(model_path=tflite_file)

interpreter.allocate_tensors()

## Predict Function
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

input_shape = input_details[0]['shape']

input_data = np.array(data, dtype=np.float32)
output_data = np.empty_like(data)

#for i in range(input_data.shape[0]): #We only want one forward pass
interpreter.set_tensor(input_details[0]['index'], input_data[0:1, :])
interpreter.invoke()
# The function `get_tensor()` returns a copy of the tensor data.
# Use `tensor()` in order to get a pointer to the tensor.
output_data[0, :] = interpreter.get_tensor(output_details[0]['index'])

#### Predict function
print("Input data [0] " + str(data[0,0]))
print("Output data [0] " + str(output_data[0,0]))
error = np.mean(np.square(data[0,:] - output_data[0,:]))
print("TFlite FP32 model Error: ")
print(error)


#####################
# Create Input data for FP32
#####################

f = open("toycar_fp32_input_data.cc", "w")
f.writelines("#include \"toycar_fp32_input_data.h\"\n")
f.writelines("const float toycar_fp32_input_data_0000[] = {\n")
for i in range(len(input_data[0][:])):
    f.write(str(input_data[0][i])+", ")
    if((i+1)%12 == 0):
       f.write("\n")
      
f.writelines("};\n")
f.writelines("const size_t toycar_fp32_input_data_0000_len = 640;\n")

f.writelines("const float* toycar_fp32_input_data[] = {toycar_fp32_input_data_0000};\n")
f.writelines("const size_t toycar_fp32_input_data_len[] = {toycar_fp32_input_data_0000_len};\n")
f.close()

#####################
# Create float input data for fp16
#####################

f = open("toycar_fp16_input_data_float.cc", "w")
f.writelines("#include \"toycar_fp16_input_data.h\"\n")
f.writelines("const float toycar_fp16_input_data_0000[] = {\n")
for i in range(len(input_data[0][:])):
    f.write(str(input_data[0][i])+", ")
    if((i+1)%12 == 0):
       f.write("\n")
      
f.writelines("};\n")
f.writelines("const size_t toycar_fp16_input_data_0000_len = 640;\n")

f.writelines("const float* toycar_fp16_input_data[] = {toycar_fp16_input_data_0000};\n")
f.writelines("const size_t toycar_fp16_input_data_len[] = {toycar_fp16_input_data_0000_len};\n")
f.close()

#####################
#Test Int8 tflite model
#####################

tflite_file = cwd + "/models/toycar_int8.tflite"
interpreter = tf.lite.Interpreter(model_path=tflite_file)

input_type = interpreter.get_input_details()[0]['dtype']
input_type = interpreter.get_input_details()[0]['dtype']

interpreter.allocate_tensors()

## Predict Function
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

input_shape = input_details[0]['shape']

input_data = np.array(data, dtype=np.int8) 
output_data = np.empty_like(data, dtype=np.int8)

#for i in range(input_data.shape[0]): #We only want one forward pass
interpreter.set_tensor(input_details[0]['index'], input_data[0:1, :])
interpreter.invoke()
# The function `get_tensor()` returns a copy of the tensor data.
# Use `tensor()` in order to get a pointer to the tensor.
output_data[0:1, :] = interpreter.get_tensor(output_details[0]['index'])

#### Predict function

error = np.mean(np.square(data[0, :] - output_data[0,:]))
print("TFlite Int8 model Error: ")
print(error)


#####################
# Create Input data for int8
#####################

f = open("toycar_int8_input_data.cc", "w")
f.writelines("#include \"toycar_int8_input_data.h\"\n")
for j in range(2):
    f.writelines("const int8_t toycar_int8_input_data_000"+str(j)+"[] = {\n")
    for i in range(len(input_data[j][:])):
        f.write(str(input_data[j][i])+", ")
        if((i+1)%12 == 0):
         f.write("\n")
      
    f.writelines("};\n")
    f.writelines("const size_t toycar_int8_input_data_000"+str(j)+"_len = 640;\n\n")

f.writelines("const int8_t* toycar_int8_input_data[] = {toycar_int8_input_data_0000, toycar_int8_input_data_0001};\n")
f.writelines("const size_t toycar_int8_input_data_len[] = {toycar_int8_input_data_0000_len, toycar_int8_input_data_0001_len};\n")
f.close()



#####################
#Test FP16 tflite model   NOTE: tflite does not support fp16 inputs/outputs, here using fp32 inputs/outputs and dequantizing to fp32 for intermediate calcs
#####################

tflite_file = cwd + "/models/toycar_fp16.tflite"
interpreter = tf.lite.Interpreter(model_path=tflite_file)

input_type = interpreter.get_input_details()[0]['dtype']
input_type = interpreter.get_input_details()[0]['dtype']

interpreter.allocate_tensors()

## Predict Function
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

input_shape = input_details[0]['shape']

input_data = np.array(data, dtype=np.float32) 
output_data = np.empty_like(data, dtype=np.float32)

#for i in range(input_data.shape[0]): #We only want one forward pass
interpreter.set_tensor(input_details[0]['index'], input_data[0:1, :])
interpreter.invoke()
# The function `get_tensor()` returns a copy of the tensor data.
# Use `tensor()` in order to get a pointer to the tensor.
output_data[0:1, :] = interpreter.get_tensor(output_details[0]['index'])

#### Predict function

error = np.mean(np.square(data[0, :] - output_data[0,:]))
print("TFlite FP16 model Error: ")
print(error)

#####################
# Create Input data for FP16
#####################

#Convert to fp16 (cannot do this for testing as tflite expects fp32 inputs
input_data = np.array(data, dtype=np.float16) 

f = open("toycar_fp16_input_data.cc", "w")
f.writelines("#include \"toycar_fp16_input_data.h\"\n")
f.writelines("const _Float16 toycar_fp16_input_data_0000[] = {\n")
for i in range(len(input_data[0][:])):
    f.write(str(input_data[0][i])+", ")
    if((i+1)%12 == 0):
       f.write("\n")
      
f.writelines("};\n")
f.writelines("const size_t toycar_fp16_input_data_0000_len = 640;\n")

f.writelines("const _Float16* toycar_fp16_input_data[] = {toycar_fp16_input_data_0000};\n")
f.writelines("const size_t toycar_fp16_input_data_len[] = {toycar_fp16_input_data_0000_len};\n")
f.close()



 
    
 



######
# Create Flatbuffer of tflite models
#####

##FP32 flatbuffer
subprocess.run("xxd -i " + cwd +"/models/toycar_fp32.tflite > "+ cwd+"/toycar_fp32_model_data.cc", shell = True, executable="/bin/bash")
fb = open(cwd +"/toycar_fp32_model_data.cc", "r+")
flatbuffer_contents = []
flatbuffer_contents.append("#include \"toycar_fp32_model_data.h\"\n")
flatbuffer_contents.append("const uint8_t toycar_fp32_model_data[] __attribute__((aligned(16))) = {\n")
fb_old_name=""
for line in fb:
    if fb_old_name != "":
        line_temp = line.replace("unsigned int", "const size_t")
        line_temp = line_temp.replace(fb_old_name, "toycar_fp32_model_data")
        flatbuffer_contents.append(line_temp)

    if "unsigned char " in line:
        fb_old_name = line.replace("unsigned char ", "")
        fb_old_name = fb_old_name.replace("[] = {", "")
        fb_old_name = fb_old_name.replace("\n","")
        
        
fb.seek(0)
fb.truncate()
for line in flatbuffer_contents:
    fb.writelines(line)

fb.close()
        
    
    





#Int8 Flatbuffer
subprocess.run("xxd -i " + cwd +"/models/toycar_int8.tflite > "+ cwd+"/toycar_int8_model_data.cc", shell = True, executable="/bin/bash")


fb = open(cwd +"/toycar_int8_model_data.cc", "r+")
flatbuffer_contents = []
flatbuffer_contents.append("#include \"toycar_int8_model_data.h\"\n")
flatbuffer_contents.append("const uint8_t toycar_int8_model_data[] __attribute__((aligned(16))) = {\n")
fb_old_name=""
for line in fb:
    if fb_old_name != "":
        line_temp = line.replace("unsigned int", "const size_t")
        line_temp = line_temp.replace(fb_old_name, "toycar_int8_model_data")
        flatbuffer_contents.append(line_temp)

    if "unsigned char " in line:
        fb_old_name = line.replace("unsigned char ", "")
        fb_old_name = fb_old_name.replace("[] = {", "")
        fb_old_name = fb_old_name.replace("\n","")
        
        
fb.seek(0)
fb.truncate()
for line in flatbuffer_contents:
    fb.writelines(line)

fb.close()


#FP16 flatbuffer
subprocess.run("xxd -i " + cwd +"/models/toycar_fp16.tflite > "+ cwd+"/toycar_fp16_model_data.cc", shell = True, executable="/bin/bash")


fb = open(cwd +"/toycar_fp16_model_data.cc", "r+")
flatbuffer_contents = []
flatbuffer_contents.append("#include \"toycar_fp16_model_data.h\"\n")
flatbuffer_contents.append("const uint8_t toycar_fp16_model_data[] __attribute__((aligned(16))) = {\n")
fb_old_name=""
for line in fb:
    if fb_old_name != "":
        line_temp = line.replace("unsigned int", "const size_t")
        line_temp = line_temp.replace(fb_old_name, "toycar_fp16_model_data")
        flatbuffer_contents.append(line_temp)

    if "unsigned char " in line:
        fb_old_name = line.replace("unsigned char ", "")
        fb_old_name = fb_old_name.replace("[] = {", "")
        fb_old_name = fb_old_name.replace("\n","")
        
        
fb.seek(0)
fb.truncate()
for line in flatbuffer_contents:
    fb.writelines(line)

fb.close()




















