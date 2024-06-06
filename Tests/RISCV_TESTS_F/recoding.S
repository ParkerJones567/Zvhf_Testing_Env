#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for infinities and zeroes with different mantissas


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    # Make sure infinities with different mantissas compare as equal.
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    feq.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    fle.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    flt.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    
    # Make sure zeroes with different mantissas compare as equal.
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    feq.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    fle.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f1, f1, f0
    flt.s a1, f0, f1
    sw a1, 0(a0)
    li a2, 0x00
    sw a2, 4(a0)
    addi a0, a0, 8
    

    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float -inf
    .float 3.0
    
    .float -inf
    .float 3.0
    
    .float -inf
    .float 3.0
    
    .float 0.0
    .float 1.0
    
    .float 0.0
    .float 1.0
    
    .float 0.0
    .float 1.0
    
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word 0x00000001
    .word 0x00000000
    
    .word 0x00000001
    .word 0x00000000
    
    .word 0x00000000
    .word 0x00000000
    
    .word 0x00000001
    .word 0x00000000
    
    .word 0x00000001
    .word 0x00000000
    
    .word 0x00000000
    .word 0x00000000
    
vref_end:




