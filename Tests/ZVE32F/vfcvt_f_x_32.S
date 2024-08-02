# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start

    li              t0, 4
    vsetvli         t0, t0, e32,m1,tu,mu

    vle32.v         v4, (a0)
    vfcvt.f.x.v     v0, v4
    vse32.v         v0, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .int           2
    .int           -2
    .int           -100
    .int           100
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:  
    .float         2.0
    .float         -2.0
    .float         -100.0
    .float         100.0
vref_end:

