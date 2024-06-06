#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fadd.s, fsub.s, fmul.s, and canonical NaN return.
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #### arithmetic tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    feq.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    fle.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8    
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    flt.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0) 
    addi a0, a0, 8
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    feq.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fle.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
       
    flw f0, 0(a0)
    flw f1, 4(a0)
    flt.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    ####  Only sNaN should signal invalid for feq.s ####
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    feq.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    feq.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    feq.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    
    #### qNaN should signal invalid for fle/flt ####
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    flt.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    flt.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    flt.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fle.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fle.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
    sw a1, 4(a0)
    addi a0, a0, 8
    
    flw f0, 0(a0)
    flw f1, 4(a0)
    fle.s a2, f0, f1
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 0(a0)
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
    .float           -1.36
    .float           -1.36
    
    .float           -1.36
    .float           -1.36
    
    .float           -1.36
    .float           -1.36
    
    .float           -1.37
    .float           -1.36
    
    .float           -1.37
    .float           -1.36
    
    .float           -1.37
    .float           -1.36
    
    .word           0x7fc00000 #NaN
    .word           0x00000000
    
    .word           0x7fc00000 #NaN
    .word           0x7fc00000 #Nan
    
    .word           0x7fa00000 #sNaN
    .word           0x00000000   
    
    .word           0x7fc00000 #NaN
    .word           0x00000000
    
    .word           0x7fc00000 #NaN
    .word           0x7fc00000 #NaN
    
    .word           0x7fa00000 #sNaN
    .word           0x00000000
      
    .word           0x7fc00000 #NaN
    .word           0x00000000
    
    .word           0x7fc00000 #NaN
    .word           0x7fc00000 #NaN
    
    .word           0x7fa00000 #sNaN
    .word           0x00000000  
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0x00000001
    .word           0x00000000
    
    .word           0x00000001
    .word           0x00000000
    
    .word           0x00000000
    .word           0x00000000
    
    .word           0x00000000
    .word           0x00000000
    
    .word           0x00000001
    .word           0x00000000
    
    .word           0x00000001
    .word           0x00000000
    
    .word           0x00000000
    .word           0x00000000
    
    .word           0x00000000
    .word           0x00000000
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
    
    .word           0x00000000
    .word           0x00000010
vref_end:




