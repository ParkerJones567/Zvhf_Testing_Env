# Copyright TUM
# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

# Outputs for Spike to report initial Instr and Cycle Count (CPI == 1 for Spike so these should be the same number)
    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word           0x00000000
    .word           0x00000000
    .word           0x00000000
    .word           0x00000000
vdata_end:
