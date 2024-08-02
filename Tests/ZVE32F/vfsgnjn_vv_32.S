# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    addi            a1, a0, 16

    li              t0, 4
    vsetvli         t0, t0, e32,m1,tu,mu

    li              t0, 1

    vle32.v         v0, (a0)
    vle32.v         v2, (a1)
    vfsgnjn.vv       v0, v0, v2
    vse32.v         v0, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word 0x12345678
    .word 0x12345678
    .word 0x92345678
    .word 0x92345678
    
    .word 0x00000000
    .word 0xffffffff
    .word 0x00000000
    .word 0xffffffff
    
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:

    .word 0x92345678
    .word 0x12345678
    .word 0x92345678
    .word 0x12345678
    
    .word 0x00000000
    .word 0xffffffff
    .word 0x00000000
    .word 0xffffffff
vref_end:
