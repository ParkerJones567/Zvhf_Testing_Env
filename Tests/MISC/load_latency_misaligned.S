# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

# This test demonstrates the latency of repeated vector loads (often present in generated code for TinyML benchmarks)
# Each load attempts to load a vector of VL=16 SEW=32 with EMUL=1 (512 total bits).  For VLEN < 512, fewer elements will be loaded.  For VLEN > 512, the entire VREG will not be used
# 
# Each load has no data dependency on the previous instruction
# 
# For this test, the load is not aligned with the data cache read port (if VMEM_W > 32).  This introduces extra control flow complexity, resulting in different latencies.
# This scenario occurs more frequently (and with a greater execution time penalty) as VMEM_W is increased



    .text
    .global main
main:
    la              a0, vdata_start
    #Loads begin 4 bytes after the start of the data region
    addi a0, a0, 4
    
    li              t0, 16
    vsetvli         t0, t0, e32,m1,tu,mu

    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)
    vle32.v         v0, (a0)
    vle32.v         v4, (a0)
    vle32.v         v8, (a0)


    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word           0xFFFFFFFF
    .int            1
    .int            2
    .int            3
    .int            4
    .int            5
    .int            6
    .int            7
    .int            8
    .int            9
    .int            10
    .int            11
    .int            12
    .int            13
    .int            14
    .int            15
    .int            16
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0xFFFFFFFF
    .int            1
    .int            2
    .int            3
    .int            4
    .int            5
    .int            6
    .int            7
    .int            8
    .int            9
    .int            10
    .int            11
    .int            12
    .int            13
    .int            14
    .int            15
    .int            16
vref_end:
