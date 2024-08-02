# Copyright TU Wien
# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    addi            a1, a0, 16

    li              t0, 8
    vsetvli         t0, t0, e16,m1,tu,mu

    li              t0, 1

    vle16.v         v0, (a0)
    flh             f1, 0(a1)
    vfadd.vf         v0, v0, f1   #THIS IS A POTENTIAL RAW HAZARD
    vse16.v         v0, (a0)

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
    .word 0x46004500 # 6.0 | 5.0
    .word 0x48004700 # 8.0 | 7.0
    .word 0x00004100 # XXXX | 2.5
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word 0x44804300 # 4.5 | 3.5
    .word 0x46804580 # 6.5 | 5.5
    .word 0x48404780 # 8.5 | 7.5
    .word 0x494048c0 # 10.5 | 9.5
    .word 0x00004100 # XXXX | 2.5
vref_end:
