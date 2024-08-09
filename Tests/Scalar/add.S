# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    la              a1, vdata_start
    
    addi            t2, x0, 12
    addi            t3, x0, 0
    
    lw              t0, 0(a0)
loop:
    lw              t1, 0(a0)
    add             t0, t0, t1
    addi            t3, t3, 1
    addi            a0, a0, 4
    blt             t3, t2, loop
    
    sw              t0, 0(a1)        

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .int            0
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
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .int            66
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
vref_end:
