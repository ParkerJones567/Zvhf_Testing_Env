#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fadd.h, fsub.h, fmul.h, and canonical NaN return.
#Each test case returns expected value and TODO(state of the accrued exception flags (fflags).)


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #### arithmetic tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    feq.h a2, f0, f1
    sw a2, 0(a0)   
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fle.h a2, f0, f1
    sw a2, 0(a0)   
    addi a0, a0, 4    
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    flt.h a2, f0, f1
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    feq.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fle.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
       
    flh f0, 0(a0)
    flh f1, 2(a0)
    flt.h a2, f0, f1
    sw a2, 0(a0)   
    addi a0, a0, 4
    
    
    ####  Only sNaN should signal invalid for feq.h ####
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    feq.h a2, f0, f1
    sw a2, 0(a0)   
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    feq.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
      
    flh f0, 0(a0)
    flh f1, 2(a0)
    feq.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
    
    
    #### qNaN should signal invalid for fle/flt ####
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    flt.h a2, f0, f1
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    flt.h a2, f0, f1
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    flt.h a2, f0, f1
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fle.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fle.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
    
    flh f0, 0(a0)
    flh f1, 2(a0)
    fle.h a2, f0, f1
    sw a2, 0(a0)  
    addi a0, a0, 4
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word 0xbd71bd71 # -1.36 | -1.36
    
    .word 0xbd71bd71 # -1.36 | -1.36
    
    .word 0xbd71bd71 # -1.36 | -1.36
    
    .word 0xbd71bd7b # -1.36 | -1.37
    
    .word 0xbd71bd7b # -1.36 | -1.37
    
    .word 0xbd71bd7b # -1.36 | -1.37
    
    .word 0x00007e00 # 0.0 | NaN
    
    .word 0x7e007e00 # NaN | NaN
    
    .word 0x00007c01 # 0.0 | sNaN
    
    .word 0x00007e00 # 0.0 | NaN
    
    .word 0x7e007e00 # NaN | NaN
    
    .word 0x00007c01 # 0.0 | sNaN
    
    .word 0x00007e00 # 0.0 | NaN
    
    .word 0x7e007e00 # NaN | NaN
    
    .word 0x00007c01 # 0.0 | sNaN 
    
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0x00000001
    
    .word           0x00000001
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000001
    
    .word           0x00000001
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
    
    .word           0x00000000
vref_end:




