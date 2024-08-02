# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start

    li              t0, 10
    vsetvli         t0, t0, e32,m4,tu,mu

    li              t0, 1

    vle32.v         v4, (a0)
    vfclass.v       v0, v4
    vse32.v         v0, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float           -inf
    .float           -1.0
    .float           -1.1754942e-38
    .float           -0
    .float           0
    .float           1.1754942e-38
    .float           1.0
    .float           inf
    .word            0x7f800001 #sNaN
    .word            0x7fc00000 #qNaN
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0x00000001
    .word           0x00000002
    .word           0x00000004
    .word           0x00000008
    .word           0x00000010
    .word           0x00000020
    .word           0x00000040
    .word           0x00000080
    .word           0x00000100
    .word           0x00000200
vref_end:
