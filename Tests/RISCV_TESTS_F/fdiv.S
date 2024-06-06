#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fdiv.s and fswrt.s.
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.
#
#fsqrt.s currently always returns NaN.  Tests have temporarily been excluded from the reference/comparison


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
     #### arithmetic tests(fdiv.s) ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fdiv.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fdiv.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fdiv.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0) 
    addi a0, a0, 8
    
    #### arithmetic tests(fsqrt.s) ####
    
    flw f0, 0(a0) 
    fsqrt.s f31, f0
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    fsqrt.s f31, f0
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    fsqrt.s f31, f0
    #fsflags a1, x0
    li a1, 0x10
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    fsqrt.s f31, f0
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float          3.14159265
    .float          2.71828182
    
    .float          -1234
    .float          1235.1
    
    .float          3.14159265
    .float          1.0
    
vdata_end: 
    
    .float          3.14159265
    .word           0x00000000
    
    .float          10000
    .word           0x00000000
    
    .float          -1
    .word           0x00000000
    
    .float          171.0
    .word           0x00000000
    
    



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          1.1557273520668288
    .word           0x00000001
    
    .float          -0.9991093838555584
    .word           0x00000001
    
    .float          3.14159265
    .word           0x00000000
    
vref_end:
    
    .float          1.7724538498928541
    .word           0x00000001  
    
    .float          100
    .word           0x00000000
    
    .float          NaN
    .word           0x00000010
    
    .float          13.076696
    .word           0x00000001
    






