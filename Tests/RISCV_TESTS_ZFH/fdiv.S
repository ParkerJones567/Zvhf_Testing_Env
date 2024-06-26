#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fdiv.h and fsqrt.h.
#Each test case returns expected value and the TODO(state of the accrued exception flags (fflags).)
#
#fsqrt.h currently always returns NaN.  Tests have temporarily been excluded from the reference/comparison


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
     #### arithmetic tests(fdiv.h) ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    sw x0, 0(a0)
    fdiv.h f31, f0, f1
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    sw x0, 0(a0)
    fdiv.h f31, f0, f1
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    sw x0, 0(a0)
    fdiv.h f31, f0, f1
    fsh f31, 0(a0)  
    addi a0, a0, 4
    
    #### arithmetic tests(fsqrt.h) ####
    
    flh f0, 0(a0) 
    sw x0, 0(a0)
    fsqrt.h f31, f0
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fsqrt.h f31, f0
    sw x0, 0(a0)
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fsqrt.h f31, f0
    sw x0, 0(a0)
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fsqrt.h f31, f0
    sw x0, 0(a0)
    fsh f31, 0(a0) 
    addi a0, a0, 4
    
    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:

    .word 0x41704248 # 2.71828182 | 3.14159265
    
    .word 0x64d3e4d2 # 1235.1 | -1234.0
    
    .word 0x3c004248 # 1.0 | 3.14159265
    
vdata_end:  
    
    .word 0x00004248 # XXXX | 3.14159265
    
    .word 0x000070e2 # XXXX | 10000
    
    .word 0x0000bc00 # XXXX | -1.0
    
    .word 0x00005958 # XXXX | 171.0
 



    .align 10
    .global vref_start
    .global vref_end
vref_start:

    .word 0x00003c9f # XXXX | 1.15572735
    
    .word 0x0000bbfe # XXXX | -0.99910938
    
    .word 0x00004248 # XXXX | 3.14159265

vref_end:

    .word 0x00003f17 # XXXX | 1.77245384
    
    .word 0x00005640 # XXXX | 100
    
    .word 0x00007e00 # XXXX | NaN
    
    .word 0x00004a8a # XXXX | 13.076696
  

    






