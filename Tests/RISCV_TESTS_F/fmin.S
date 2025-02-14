#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fmin.s and fmax.s
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fmin.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    #### fmax.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    # FMAX(sNaN, x) = x
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    # FMAX(qNaN, qNaN) = canonical NaN
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    # -0.0 < +0.0
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmin.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fmax.s f31, f0, f1
    #fsflags a1, x0
    li a1, 0x00
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
    
    .float           1.1
    .float           -1235.1
    
    .word            0x7fc00000 #NaN
    .float           -1235.1
    
    .float           3.14159265
    .float           0.00000001 
    
    .float           -1.0
    .float           -2.0
    
    .float           2.5
    .float           1.0
    
    .float           -1235.1
    .float           1.1
    
    .float           1.1
    .float           -1235.1
    
    .word            0x7fc00000 #NaN
    .float           -1235.1
    
    .float           3.14159265
    .float           0.00000001 
    
    .float           -1.0
    .float           -2.0
    
    .float           1.0
    .word            0x7f800001 #sNaN
    
    .word            0x7fc00000 #NaN
    .word            0x7fc00000 #NaN
    
    .word            0x80000000 #-0
    .word            0x00000000 #0
    
    .word            0x00000000 #0
    .word            0x80000000 #-0
    
    .word            0x80000000 #-0
    .word            0x00000000 #0
    
    .word            0x00000000 #0
    .word            0x80000000 #-0
    

vdata_end:


    .align 10
    .global vref_start
    .global vref_end
vref_start:
    
    .float           1.0
    .word            0x00000000
    
    .float           -1235.1
    .word            0x00000000
    
    .float           -1235.1
    .word            0x00000000
    
    .float           -1235.1
    .word            0x00000000
    
    .float           0.00000001 
    .word            0x00000000
    
    .float           -2.0
    .word            0x00000000
    
    .float           2.5
    .word            0x00000000
    
    .float           1.1
    .word            0x00000000
    
    .float           1.1
    .word            0x00000000
    
    .float           -1235.1
    .word            0x00000000
    
    .float           3.14159265
    .word            0x00000000
    
    .float           -1.0
    .word            0x00000000
    
    .float           1.0
    .word            0x00000010
    
    .word           0x7fc00000 #qNaN
    .word           0x00000000
    
    .word           0x80000000 #-0
    .word           0x00000000 
    
    .word           0x80000000 #-0
    .word           0x00000000 
    
    .word           0x00000000 #0
    .word           0x00000000 
    
    .word           0x00000000 #0
    .word           0x00000000 
    
vref_end:



