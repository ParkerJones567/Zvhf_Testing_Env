# Copyright TUM
# Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

.section .vectors, "ax", @progbits
.option norvc;

    # redirect all interrupts to the execption wrapper
    .rept 31
    nop
    .endr
    j exc_wrapper

    # the reset vector is redirected to _start
    j _start
    
exc_wrapper:
    li t0, 0xFFFFFFFF     #LSB exits spike, all other bits signal failure
    la t1, tohost
    sw t0, 0(t1)
    j exc_wrapper
    
    
    
    
    .text
    .balign 4
    .global _start
_start:                                 #New _start section to set mstatus bits properly
    csrr            a0, mstatus
    li              a1, 0x00002200      #Init FS bits to enable F-EXT and VS bits to enable V-EXT
    or              a0, a0, a1
    csrw            mstatus, a0
    
    csrr            a0, mtvec
    li              a1, 0x80000000      #Set address of interrupt vector table
    or              a0, a0, a1
    csrw            mtvec, a0
    
    j main
    
    
    
    .text
    .balign 4
    .global spill_cache
spill_cache:                            #Replacement for spill cache file to signal end of execution for spike sim without changes to the original test file

    li t0, 1
    la t1, tohost
    sw t0, 0(t1)
    
    1: j 1b
    
    
.align 4; .global tohost;   tohost:   .dword 0
.align 4; .global fromhost; fromhost: .dword 0
