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
    flw             f1, 0(a1)
    vfmin.vf         v0, v0, f1
    vse32.v         v0, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float          1.0
    .float          2.0
    .float          3.0
    .float          4.0
    .float          2.5
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          1.0
    .float          2.0
    .float          2.5
    .float          2.5
    .float          2.5
vref_end:
