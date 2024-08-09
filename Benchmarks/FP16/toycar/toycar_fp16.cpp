#include <cmath>
#include <cstdarg>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include "model_data/toycar_fp16_input_data.h"
#include "model_data/toycar_fp16_model_data.h"
#include "model_data/toycar_fp16_model_settings.h"
#include "model_data/toycar_fp16_output_data_ref.h"

extern "C" {
#include "runtime.h"
#include "uart.h"
#include "terminate_benchmark.h"
}

constexpr size_t tensor_arena_size = 256 * 1024 * 4; //x4 for float TODO: x2 for FP16
alignas(16) uint8_t tensor_arena[tensor_arena_size];

int run_test()
{
    
    tflite::MicroErrorReporter micro_error_reporter;
    tflite::ErrorReporter *error_reporter = &micro_error_reporter;

    const tflite::Model *model = tflite::GetModel(toycar_fp16_model_data);

    static tflite::MicroMutableOpResolver<1> resolver;
    resolver.AddFullyConnected();

    tflite::MicroInterpreter interpreter(model, resolver, tensor_arena, tensor_arena_size);

    if (interpreter.AllocateTensors() != kTfLiteOk)
    {
        //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In AllocateTensors().");
        return -1;
    }

    for (size_t i = 0; i < toycar_fp16_data_sample_cnt; i++)
    {
        memcpy(interpreter.input(0)->data.f, (float *)toycar_fp16_input_data[i], toycar_fp16_input_data_len[i]);

        if (interpreter.Invoke() != kTfLiteOk)
        {
            //TF_LITE_REPORT_ERROR(error_reporter, "ERROR: In Invoke().");
            return -1;
        }

        /*float sum = 0;
        for (size_t j = 0; j < toycar_fp16_input_data_len[i]; j++)
        {
            sum += pow((float)toycar_fp16_input_data[i][j] - interpreter.output(0)->data.f[j], 2);
        }
        sum /= toycar_fp16_input_data_len[i];

        float diff = abs(sum - toycar_fp16_output_data_ref[i]);
        if (diff > 100.0)
        {
            uart_printf("ERROR: at #%d, sum %f ref %f diff %f \n", i, sum, toycar_fp16_output_data_ref[i], diff);
            return -1;
        }
        else
        {
            uart_printf("Sample #%d pass, sum %f ref %f diff %f \n", i, sum, toycar_fp16_output_data_ref[i], diff);
            return 0;
        }*/
    }
    
    return 0;
}

int main(int argc, char *argv[])
{
    int ret = run_test();
    if (ret != 0)
    {
        benchmark_failure();
    }
    else
    {
        benchmark_success(); 
    }

    return ret;
}
