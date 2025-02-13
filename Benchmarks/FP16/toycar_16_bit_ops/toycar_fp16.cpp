
#include "tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include "toycar_fp16_data/toycar_fp16_input_data.h"
#include "toycar_fp16_data/toycar_fp16_model_data.h"
#include "toycar_fp16_data/toycar_fp16_model_settings.h"
#include "toycar_fp16_data/toycar_fp16_output_data_ref.h"

extern "C" {
#include "runtime.h"
#include "uart.h"
#include "terminate_benchmark.h"
}

constexpr size_t tensor_arena_size = 256 * 1024 * 4 + 25000; //x4 for float //Cannot reduce this by 1/2 for HalfFloat, as TFLM is expecting intermediate ops to be using Float (+25000 for error caused by adding DEQUANTIZE OP)
alignas(16) uint8_t tensor_arena[tensor_arena_size];

//Due to no proper FP16 support for operations, inputs, and outputs, values will be passed in as float.  pointers will be cast to _Float16 within kernels
int run_test()
{
    //tflite::MicroErrorReporter micro_error_reporter;
    //tflite::ErrorReporter *error_reporter = &micro_error_reporter;

    const tflite::Model *model = tflite::GetModel(toycar_fp16_model_data);

    static tflite::MicroMutableOpResolver<2> resolver;
    resolver.AddFullyConnected();
    resolver.AddDequantize();

    tflite::MicroInterpreter interpreter(model, resolver, tensor_arena, tensor_arena_size);
    
    if (interpreter.AllocateTensors() != kTfLiteOk)
    {
        //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In AllocateTensors().");
        return -1;
    }
    
    for (size_t i = 0; i < toycar_fp16_data_sample_cnt; i++)
    {
        memcpy(interpreter.input(0)->data.f, (float *)toycar_fp16_input_data[i], toycar_fp16_input_data_len[i] * 2); //Bytes to copy is 2*len (FP16)

        if (interpreter.Invoke() != kTfLiteOk)
        {
            //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In Invoke().");
            return -1;
        }

        _Float16 sum = 0;
        _Float16* output_data = (_Float16 *)(interpreter.output(0)->data.f);
        for (size_t j = 0; j < toycar_fp16_input_data_len[i]; j++)
        {
            sum += (toycar_fp16_input_data[i][j] - output_data[j]) * (toycar_fp16_input_data[i][j] - output_data[j]);
        }
        sum /= (_Float16)toycar_fp16_input_data_len[i];

        _Float16 diff = sum - toycar_fp16_output_data_ref[i]; //TODO:abs() makes negative error 0.00?
        
        //store_result_float(((float)sum));
        if ((diff > 0.1f16) | (diff < -0.1f16))
        {
            #if defined(PRINT_OUTPUTS)
            uart_printf("ERROR: at #%d, sum %f ref %f diff %f \n", i, (float)sum, (float)toycar_fp16_output_data_ref[i], (float)diff);
            #endif
            return -1;
        }
        else
        {
            #if defined(PRINT_OUTPUTS)
            uart_printf("Sample #%d pass, sum %f ref %f diff %f \n", i, (float)sum, (float)toycar_fp16_output_data_ref[i], (float)diff);
            #endif
        }
    }
    
    return 0;
}

int main(int argc, char *argv[])
{
    int ret = run_test();
    if (ret != 0)
    {
        #if defined(PRINT_OUTPUTS)
        uart_printf("Test Failed!\n");
        #endif 
        benchmark_failure();
    }
    else
    {
        #if defined(PRINT_OUTPUTS)
        uart_printf("Test Success!\n");
        #endif
        benchmark_success(); 
    }

    return ret;
}
