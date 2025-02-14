# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start

    li              t0, 8
    vsetvli         t0, t0, e32,m2,tu,mu

    li              t0, 1

    vle32.v         v0, (a0)
    vfmv.f.s        fa2, v0
    fsw             fa2, 28(a0)

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
    .float          -1.0
    .float          -2.0
    .float          -3.0
    .float          -4.0
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          1.0
    .float          2.0
    .float          3.0
    .float          4.0
    .float          -1.0
    .float          -2.0
    .float          -3.0
    .float          1.0
vref_end:
