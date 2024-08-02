# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    addi            a1, a0, 32

    li              t0, 8
    vsetvli         t0, t0, e32,m2,tu,mu

    li              t0, 1

    vle32.v         v0, (a0)
    vle32.v         v2, (a1)
    vfsub.vv         v0, v0, v2
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
    .float          -1.0
    .float          -2.0
    .float          -3.0
    .float          -4.0
    .float          2.5
    .float          2.5
    .float          -2.5
    .float          -2.5
    .float          2.5
    .float          2.5
    .float          -2.5
    .float          -2.5
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          -1.5
    .float          -0.5
    .float          5.5
    .float          6.5
    .float          -3.5
    .float          -4.5
    .float          -0.5
    .float          -1.5
    .float          2.5
    .float          2.5
    .float          -2.5
    .float          -2.5
    .float          2.5
    .float          2.5
    .float          -2.5
    .float          -2.5
vref_end:
