# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

# This test performs a simple addition of a scalar with a long vector
# When the length of the vector is longer than the width of an individual cache line, the vector load/store operation generates MULTIPLE misses.
# This causes the instruction to experience the cache miss penalty multiple times per load/store, which can be observed in the reported miss/hit count (TODO:) as well as the cycles taken to complete the program.
# Additionally, the vector is stored offset by 4 bytes in memory, to demonstrate the impact of memory operations that cross multiple cache lines.
# 
# Intended VLEN == 512 bits (16 elements)
# with DCACHE_LINE_W == 256, the vector unit will experience 3 cache misses on the first load operation.
# with DCACHE_LINE_W == 512, the vector unit will experience 2 cache misses on the first load.
# with DCACHE_LINE_W == 1024, the vector unit will experience 1 cache miss on the first load.
# 



    .text
    .global main
main:
    la              a0, vdata_start
    addi            a0, a0, 4
    
    li              t0, 16
    vsetvli         t0, t0, e32,m1,tu,mu

    li              t0, 100

    vle32.v         v0, (a0)
    
    vadd.vx         v0, v0, t0
    
    vse32.v         v0, (a0)

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
    .int            101
    .int            102
    .int            103
    .int            104
    .int            105
    .int            106
    .int            107
    .int            108
    .int            109
    .int            110
    .int            111
    .int            112
    .int            113
    .int            114
    .int            115
    .int            116
vref_end:
