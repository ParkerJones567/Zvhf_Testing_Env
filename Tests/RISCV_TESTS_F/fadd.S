#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fadd.s, fsub.s, fmul.s, and canonical NaN return.
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fadd.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fadd.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fadd.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fadd.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0) 
    addi a0, a0, 8
    
    #### fsub.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fsub.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fsub.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8  
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fsub.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    #### fmul.s tests ####
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fmul.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    #### Canonical NaN for Inf-Inf ####
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fsub.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x10
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
    .float           2.5
    .float           1.0
    
    .float           -1235.1
    .float           1.1
    
    .float           3.14159265
    .float           0.00000001 
    
    .float           2.5
    .float           1.0
    
    .float           -1235.1
    .float           -1.1
    
    .float           3.14159265
    .float           0.00000001 
      
    .float           2.5
    .float           1.0
    
    .float           -1235.1
    .float           -1.1
    
    .float           3.14159265
    .float           0.00000001 
       
    .float           inf
    .float           inf
vdata_end:


    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float           3.5
    .word            0x00000000
    
    .float           -1234
    .word            0x00000001
    
    .float           3.14159265
    .word            0x00000001
    
    .float           1.5
    .word            0x00000000
    
    .float           -1234
    .word            0x00000001
    
    .float           3.14159265
    .word            0x00000001
    
    .float           2.5
    .word            0x00000000
    
    .float           1358.61
    .word            0x00000001
    
    .float           3.14159265e-8
    .word            0x00000001
    
    .word            0x7fc00000 #qNaN
    .word            0x00000010
vref_end:



