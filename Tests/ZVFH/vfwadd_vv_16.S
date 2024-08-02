# Copyright TU Wien
# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    addi            a1, a0, 16

    li              t0, 4
    vsetvli         t0, t0, e16,m1,tu,mu

    li              t0, 1

    vle16.v         v0, (a0)
    vle16.v         v2, (a1)
    vfwadd.vv       v4, v0, v2
    vse32.v         v4, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word 0x40003c00 # 2.0 | 1.0
    .word 0x44004200 # 4.0 | 3.0
    .word 0x00000000
    .word 0x00000000
    .word 0x41004100 # 2.5 | 2.5
    .word 0x41004100 # 2.5 | 2.5

vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float 4.5
    .float 5.5
    .float 6.5
    .float 7.5
    .word 0x41004100 # 2.5 | 2.5
    .word 0x41004100 # 2.5 | 2.5

vref_end:
