#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for infinities and zeroes with different mantissas


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    # Make sure infinities with different mantissas compare as equal.
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    feq.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    fle.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    flt.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    
    # Make sure zeroes with different mantissas compare as equal.
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    feq.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    fle.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fmul.h f1, f1, f0
    flt.h a1, f0, f1
    sw a1, 0(a0)
    addi a0, a0, 4
    

    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:

    .word 0x4200fc00 # 3.0 | -inf
    
    .word 0x4200fc00 # 3.0 | -inf
    
    .word 0x4200fc00 # 3.0 | -inf
    
    .word 0x3c000000 # 1.0 | 0.0
    
    .word 0x3c000000 # 1.0 | 0.0
    
    .word 0x3c000000 # 1.0 | 0.0
   
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word 0x00000001
    
    .word 0x00000001
    
    .word 0x00000000
    
    .word 0x00000001
    
    .word 0x00000001
    
    .word 0x00000000
    
vref_end:




