# Copyright TUM
# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

# Outputs for Vicuna to report initial Instr and Cycle Count
# Final spot is for the benchmark result value

    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word           0x00000000
    .word           0x00000000
    .word           0x00000000
    .word           0x00000000
    .word           0x00000000
vdata_end:


#Todo, unused, needed by Verilator Main when dumping (TODO: FIX THIS)
    .data
    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0x00000001
    .word           0x00000002
    .word           0x00000003
    .word           0x00000004
    .word           0x00000005
vref_end:
