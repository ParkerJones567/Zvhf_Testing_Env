#include <cstdarg>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "aww_fp16_data/aww_fp16_input_data.h"
#include "aww_fp16_data/aww_fp16_model_data.h"
#include "aww_fp16_data/aww_fp16_model_settings.h"
#include "aww_fp16_data/aww_fp16_output_data_ref.h"

#include "tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/schema/schema_generated.h"

extern "C" {
#include "runtime.h"
#include "uart.h"
#include "terminate_benchmark.h"
}

constexpr size_t tensor_arena_size = 256 * 1024 * 4;
alignas(16) uint8_t tensor_arena[tensor_arena_size];

int run_test()
{
    //tflite::MicroErrorReporter micro_error_reporter;
    //tflite::ErrorReporter *error_reporter = &micro_error_reporter;

    const tflite::Model *model = tflite::GetModel(aww_fp16_model_data);

    static tflite::MicroMutableOpResolver<7> resolver;
    resolver.AddFullyConnected();
    resolver.AddConv2D();
    resolver.AddDepthwiseConv2D();
    resolver.AddAveragePool2D();
    resolver.AddReshape();
    resolver.AddSoftmax();
    resolver.AddDequantize();

    tflite::MicroInterpreter interpreter(model, resolver, tensor_arena, tensor_arena_size);

    if (interpreter.AllocateTensors() != kTfLiteOk)
    {
        //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In AllocateTensors().");
        return -1;
    }

    //for (size_t i = 0; i < aww_fp16_data_sample_cnt; i++)
    for (size_t i = 0; i < 1; i++)
    {
        memcpy(interpreter.input(0)->data.f, (float *)aww_fp16_input_data[i], aww_fp16_input_data_len[i] * 2); //Bytes to copy is 4*len

        if (interpreter.Invoke() != kTfLiteOk)
        {
            //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In Invoke().");
            return -1;
        }

        int8_t top_index = 0;
        _Float16* output_ptr = (_Float16*)interpreter.output(0)->data.f;
        for (size_t j = 0; j < aww_fp16_model_label_cnt; j++)
        {
            if (output_ptr[j] > output_ptr[top_index])
            {
                top_index = j;
            }
        }

        if (top_index != aww_fp16_output_data_ref[i])
        {
            //uart_printf("ERROR: at #%d, top_index %d aww_fp16_output_data_ref %d \n", i, top_index, aww_fp16_output_data_ref[i]);
            return -1;
        }
        else
        {
            //uart_printf("Sample #%d pass, top_index %d matches ref %d \n", i, top_index, aww_fp16_output_data_ref[i]);
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
