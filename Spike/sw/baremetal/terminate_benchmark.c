#include "terminate_benchmark.h"

void benchmark_success()
{
    __asm__ volatile("li t0, 0x00000001");     //LSB exits spike, all other bits signal failure
    __asm__ volatile("la t1, tohost");
    __asm__ volatile("sw t0, 0(t1)");
    __asm__ volatile("unimp");                 //Shouldnt reach here, but jump to exception handler
}

void benchmark_failure()
{
    __asm__ volatile("li t0, 0xFFFFFFFF");     //LSB exits spike, all other bits signal failure
    __asm__ volatile("la t1, tohost");
    __asm__ volatile("sw t0, 0(t1)");
    __asm__ volatile("unimp");                 //Shouldnt reach here, but jump to exception handler
}
