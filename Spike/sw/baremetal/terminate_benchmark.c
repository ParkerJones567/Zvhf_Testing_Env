#include "terminate_benchmark.h"

void benchmark_success()
{

    __asm__ volatile("la              a0, vdata_start"); //Store the cycle and instruction count for benchmarks run on spike
    __asm__ volatile("csrr            a1, cycle"); 
    __asm__ volatile("sw              a1, 8(a0)"); 
    __asm__ volatile("csrr            a1, minstret"); 
    __asm__ volatile("sw              a1, 12(a0)"); 
    
    __asm__ volatile("li t0, 0x00000001");     //LSB exits spike, all other bits signal failure
    __asm__ volatile("la t1, tohost");
    __asm__ volatile("sw t0, 0(t1)");
    __asm__ volatile("unimp");                 //Shouldnt reach here, but jump to exception handler
}

void benchmark_failure()
{
    __asm__ volatile("la              a0, vdata_start"); //Store the cycle and instruction count for benchmarks run on spike
    __asm__ volatile("csrr            a1, cycle");
    __asm__ volatile("sw              a1, 8(a0)");
    __asm__ volatile("csrr            a1, minstret");
    __asm__ volatile("sw              a1, 12(a0)");
    
    __asm__ volatile("li t0, 0xFFFFFFFF");     //LSB exits spike, all other bits signal failure
    __asm__ volatile("la t1, tohost");
    __asm__ volatile("sw t0, 0(t1)");
    __asm__ volatile("unimp");                 //Shouldnt reach here, but jump to exception handler
}

void start_cycle_count()
{
    //Store the cycle and instruction count for benchmarks run on spike
    __asm__ volatile("la              a0, vdata_start\n" 
                     "csrr            a1, cycle\n"
                     "sw              a1, 0(a0)\n"
                     "csrr            a1, minstret\n"
                     "sw              a1, 4(a0)\n"
                      : : : "a0","a1");
    return;
}
void store_result_float(float result)
{
 //   __asm__ volatile("la              a0, vdata_start\n"
 //                   "fsw             %0, 16(a0)\n"
 //                    : : "f" (result) : "a0" );
    return;
}

void store_result_int(uint32_t result)
{
    __asm__ volatile("la              a0, vdata_start\n"
                     "sw              %0, 16(a0)\n"
                     : : "r" (result) : "a0" );
    return;
}
