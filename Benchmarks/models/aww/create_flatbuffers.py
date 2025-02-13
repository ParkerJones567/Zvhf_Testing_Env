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

import get_dataset as kws_data
import kws_util


if __name__ == '__main__':

    Flags, unparsed = kws_util.parse_command()

    cwd = str(Path.cwd())


    #################
    #load original trained model
    #################
    model = keras.models.load_model(cwd + "/models/aww.h5") 





    #########################
    #load test data 
    #########################
    #For aww, helper function from TinyMLPerf included
    _, _, ds_val = kws_data.get_training_data(Flags, val_cal_subset=True)
    
    
    data, label = ds_val.unbatch().batch(1).as_numpy_iterator().next()
    
    data_flat = data.flatten()
                                                             
    #######################
    # Run a forward pass of original model
    #######################


    #######################
    # Make FP32 tflite model
    #######################

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    tflite_file = cwd + "/models/aww_fp32.tflite"
    with tf.io.gfile.GFile(tflite_file, 'wb') as f:
        f.write(tflite_model) 
     
    #######################
    # Make INT8 tflite model
    ####################### 
    converter = tf.lite.TFLiteConverter.from_keras_model(model)

    with open("quant_cal_idxs.txt") as fpi:
        cal_indices = [int(line) for line in fpi]
        cal_indices.sort()


    ds_val = ds_val.unbatch().batch(1) 
    num_calibration_steps = len(cal_indices)
    # Function to Generate Input data for INT8 model (needed for full int quantization)
    ds_iter = ds_val.as_numpy_iterator()
    def representative_dataset_gen():
        for _ in range(num_calibration_steps):
          next_input = next(ds_iter)[0]
          yield [next_input]

    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.representative_dataset = representative_dataset_gen
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
    converter.inference_input_type = tf.int8  # or tf.uint8; should match dat_q in eval_quantized_model.py
    converter.inference_output_type = tf.int8  # or tf.uint8
    tflite_model = converter.convert()
    tflite_file = cwd + "/models/aww_int8.tflite"
    with tf.io.gfile.GFile(tflite_file, 'wb') as f:
        f.write(tflite_model)




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

    tflite_file = cwd + "/models/aww_fp16.tflite"
    with tf.io.gfile.GFile(tflite_file, 'wb') as f:
        f.write(tflite_model)












    #####################
    #Test FP32 tflite model
    #####################
    

    tflite_file = cwd + "/models/aww_fp32.tflite"
    interpreter = tf.lite.Interpreter(model_path=tflite_file)

    interpreter.allocate_tensors()

    ## Predict Function
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    input_shape = input_details[0]['shape']

    input_data = np.array(data, dtype=np.float32)
    output_data = []

    #for i in range(input_data.shape[0]): #We only want one forward pass
    interpreter.set_tensor(input_details[0]['index'], data)
    interpreter.invoke()
    # The function `get_tensor()` returns a copy of the tensor data.
    # Use `tensor()` in order to get a pointer to the tensor.
    output_data.append(np.argmax(interpreter.get_tensor(output_details[0]['index'])))

    #### Predict function
    print("Output Label " + str(output_data[0]))
    print("Reference label " + str(label))



    #####################
    # Create Input data for FP32
    #####################
    
    f = open("aww_fp32_input_data.cc", "w")
    f.writelines("#include \"aww_fp32_input_data.h\"\n")
    f.writelines("const float aww_fp32_input_data_0000[] = {\n")
    for i in range(len(data_flat)):
        f.write(str(data_flat[i])+", ")
        if((i+1)%12 == 0):
            f.write("\n")
    f.writelines("};\n")
    f.writelines("const size_t aww_fp32_input_data_0000_len = 490;\n")

    f.writelines("const float* aww_fp32_input_data[] = {aww_fp32_input_data_0000};\n")
    f.writelines("const size_t aww_fp32_input_data_len[] = {aww_fp32_input_data_0000_len};\n")
    f.close()

    #####################
    # Create float input data for fp16
    #####################

    #f = open("aww_fp16_input_data_float.cc", "w")
    #f.writelines("#include \"aww_fp16_input_data.h\"\n")
    #f.writelines("const float aww_fp16_input_data_0000[] = {\n")
    #for i in range(len(data_flat)):
    #    f.write(str(data_flat[i])+", ")
    #    if((i+1)%12 == 0):
    #       f.write("\n")

    #f.writelines("};\n")
    #f.writelines("const size_t aww_fp16_input_data_0000_len = 490;\n")

    #f.writelines("const float* aww_fp16_input_data[] = {aww_fp16_input_data_0000};\n")
    #f.writelines("const size_t aww_fp16_input_data_len[] = {aww_fp16_input_data_0000_len};\n")
    #f.close()

    #####################
    #Test Int8 tflite model
    #####################
    
    

    tflite_file = cwd + "/models/aww_int8.tflite"
    interpreter = tf.lite.Interpreter(model_path=tflite_file)
    
    

    input_type = interpreter.get_input_details()[0]['dtype']
    input_type = interpreter.get_input_details()[0]['dtype']

    interpreter.allocate_tensors()

    ## Predict Function
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    input_scale, input_zero_point = input_details[0]["quantization"]
    data_q = np.array(data/input_scale + input_zero_point, dtype=np.int8)
    output_data = []

    input_shape = input_details[0]['shape']

    #for i in range(input_data.shape[0]): #We only want one forward pass
    interpreter.set_tensor(input_details[0]['index'], data_q)
    interpreter.invoke()
    # The function `get_tensor()` returns a copy of the tensor data.
    # Use `tensor()` in order to get a pointer to the tensor.
    output_data.append(np.argmax(interpreter.get_tensor(output_details[0]['index'])))

    #### Predict function
    print("Quantized Test")
    print("Output Label " + str(output_data[0]))
    print("Reference label " + str(label))



    #####################
    # Create Input data for int8
    #####################
    
    data_q_flat = data_q.flatten()
    j=0
    f = open("aww_int8_input_data.cc", "w")
    f.writelines("#include \"aww_int8_input_data.h\"\n")
    f.writelines("const int8_t aww_int8_input_data_000"+str(j)+"[] = {\n")
    for i in range(len(data_q_flat)):
        f.write(str(data_q_flat[i])+", ")
        if((i+1)%12 == 0):
            f.write("\n")
      
    f.writelines("};\n")
    f.writelines("const size_t aww_int8_input_data_000"+str(j)+"_len = 490;\n\n")

    f.writelines("const int8_t* aww_int8_input_data[] = {aww_int8_input_data_0000};\n")
    f.writelines("const size_t aww_int8_input_data_len[] = {aww_int8_input_data_0000_len};\n")
    f.close()



    #####################
    #Test FP16 tflite model   NOTE: tflite does not support fp16 inputs/outputs, here using fp32 inputs/outputs and dequantizing to fp32 for intermediate calcs
    #####################

    #tflite_file = cwd + "/models/aww_fp16.tflite"
    #interpreter = tf.lite.Interpreter(model_path=tflite_file)

    #input_type = interpreter.get_input_details()[0]['dtype']
    #input_type = interpreter.get_input_details()[0]['dtype']

    #interpreter.allocate_tensors()

    ## Predict Function
    #input_details = interpreter.get_input_details()
    #output_details = interpreter.get_output_details()

    #input_shape = input_details[0]['shape']

    #input_data = np.array(data, dtype=np.float32) 
    #output_data = np.empty_like(data, dtype=np.float32)

    #for i in range(input_data.shape[0]): #We only want one forward pass
    #interpreter.set_tensor(input_details[0]['index'], input_data[0:1, :])
    #interpreter.invoke()
    # The function `get_tensor()` returns a copy of the tensor data.
    # Use `tensor()` in order to get a pointer to the tensor.
    #output_data[0:1, :] = interpreter.get_tensor(output_details[0]['index'])

    #### Predict function

    #error = np.mean(np.square(data[0, :] - output_data[0,:]))
    #print("TFlite FP16 model Error: ")
    #print(error)

    #####################
    # Create Input data for FP16
    #####################

    #Convert to fp16 (cannot do this for testing as tflite expects fp32 inputs
    input_data = np.array(data_flat, dtype=np.float16) 

    f = open("aww_fp16_input_data.cc", "w")
    f.writelines("#include \"aww_fp16_input_data.h\"\n")
    f.writelines("const _Float16 aww_fp16_input_data_0000[] = {\n")
    for i in range(len(input_data)):
        f.write(str(input_data[i])+", ")
        if((i+1)%12 == 0):
           f.write("\n")

    f.writelines("};\n")
    f.writelines("const size_t aww_fp16_input_data_0000_len = 640;\n")

    f.writelines("const _Float16* aww_fp16_input_data[] = {aww_fp16_input_data_0000};\n")
    f.writelines("const size_t aww_fp16_input_data_len[] = {aww_fp16_input_data_0000_len};\n")
    f.close()









    ######
    # Create Flatbuffer of tflite models
    #####

    #FP32 flatbuffer
    subprocess.run("xxd -i " + cwd +"/models/aww_fp32.tflite > "+ cwd+"/aww_fp32_model_data.cc", shell = True, executable="/bin/bash")
    fb = open(cwd +"/aww_fp32_model_data.cc", "r+")
    flatbuffer_contents = []
    flatbuffer_contents.append("#include \"aww_fp32_model_data.h\"\n")
    flatbuffer_contents.append("const uint8_t aww_fp32_model_data[] __attribute__((aligned(16))) = {\n")
    fb_old_name=""
    for line in fb:
        if fb_old_name != "":
            line_temp = line.replace("unsigned int", "const size_t")
            line_temp = line_temp.replace(fb_old_name, "aww_fp32_model_data")
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
    subprocess.run("xxd -i " + cwd +"/models/aww_int8.tflite > "+ cwd+"/aww_int8_model_data.cc", shell = True, executable="/bin/bash")


    fb = open(cwd +"/aww_int8_model_data.cc", "r+")
    flatbuffer_contents = []
    flatbuffer_contents.append("#include \"aww_int8_model_data.h\"\n")
    flatbuffer_contents.append("const uint8_t aww_int8_model_data[] __attribute__((aligned(16))) = {\n")
    fb_old_name=""
    for line in fb:
        if fb_old_name != "":
            line_temp = line.replace("unsigned int", "const size_t")
            line_temp = line_temp.replace(fb_old_name, "aww_int8_model_data")
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
    subprocess.run("xxd -i " + cwd +"/models/aww_fp16.tflite > "+ cwd+"/aww_fp16_model_data.cc", shell = True, executable="/bin/bash")


    fb = open(cwd +"/aww_fp16_model_data.cc", "r+")
    flatbuffer_contents = []
    flatbuffer_contents.append("#include \"aww_fp16_model_data.h\"\n")
    flatbuffer_contents.append("const uint8_t aww_fp16_model_data[] __attribute__((aligned(16))) = {\n")
    fb_old_name=""
    for line in fb:
        if fb_old_name != "":
            line_temp = line.replace("unsigned int", "const size_t")
            line_temp = line_temp.replace(fb_old_name, "aww_fp16_model_data")
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




















