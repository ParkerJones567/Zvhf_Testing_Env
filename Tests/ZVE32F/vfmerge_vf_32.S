# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


    .text
    .global main
main:
    la              a0, vdata_start
    la              a1, vdata_end

    li              t0, 16
    vsetvli         t0, t0, e32,m4,tu,mu

    flw             f1, -4(a1)

    vle32.v         v0, (a0)
    vfmerge.vfm     v4, v0, f1, v0
    vse32.v         v4, (a0)

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word           0x323bbf47
    .word           0xc7434b3a
    .word           0x302f2e32
    .word           0xe8404a51
    .word           0x3f44383b
    .word           0x37424d54
    .word           0x5e4b5049
    .word           0x4c4c4c4a
    .word           0x4a505f3e
    .word           0x485e5455
    .word           0x4d4c4a41
    .word           0x373b5451
    .word           0x41454c45
    .word           0x3a3e3738
    .word           0x312f2e2f
    .word           0x3d433f45
    .word           0x46424949
    .word           0x494a4d51
    .word           0x49413c38
    .word           0x3e514143
    .word           0x47525353
    .word           0x514e5052
    .word           0x525a5b58
    .word           0x5e575254
    .word           0x56545058
    .word           0x5a534947
    .word           0x4744544f
    .word           0x4e515051
    .word           0x5a4b4545
    .word           0x454c4342
    .word           0x40504a3f
    .float          2.5
vdata_end:

    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          2.5
    .float          2.5
    .float          2.5
    .word           0xe8404a51
    .word           0x3f44383b
    .word           0x37424d54
    .float          2.5
    .word           0x4c4c4c4a
    .float          2.5
    .float          2.5
    .float          2.5
    .float          2.5
    .float          2.5
    .float          2.5
    .word           0x312f2e2f
    .float          2.5
    .word           0x46424949
    .word           0x494a4d51
    .word           0x49413c38
    .word           0x3e514143
    .word           0x47525353
    .word           0x514e5052
    .word           0x525a5b58
    .word           0x5e575254
    .word           0x56545058
    .word           0x5a534947
    .word           0x4744544f
    .word           0x4e515051
    .word           0x5a4b4545
    .word           0x454c4342
    .word           0x40504a3f
    .float          2.5
vref_end:
