#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fadd.h, fsub.h, fmul.h, and canonical NaN return.
#Each test case returns expected value TODO(state of the accrued exception flags (fflags).)



    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fadd.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fadd.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fadd.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fadd.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
       
    #### fsub.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fsub.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fsub.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
       
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fsub.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
       
    #### fmul.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmul.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmul.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmul.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    #### Canonical NaN for Inf-Inf ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fsub.h f31, f0, f1
    li a1, 0x00
    sw a1, 0(a0)
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

    .word 0x41003c00 # 2.5 | 1.0
    
    .word 0x3c66e4d3 # 1.1 | -1235.1
    
    .word 0x00024248 # 0.0000001 | 3.141
    
    .word 0x3c004100 # 1.0 | 2.5
    
    .word 0xbc66e4d3 # -1.1 | -1235.1
    
    .word 0x00024248 # 0.0000001 | 3.141
    
    .word 0x3c004100 # 1.0 | 2.5
    
    .word 0xbc66e4d3 # -1.1 | -1235.1
    
    .word 0x00024248 # 0.0000001 | 3.141
    
    .word 0x7c007c00 # inf | inf
    
vdata_end:
    




    .align 10
    .global vref_start
    .global vref_end
vref_start:

    .word 0x00004300 # XXXX | 3.5
    
  
    .word 0x0000e4d2 # XXXX | -1234.0
    
    .word 0x00004248 # XXXX | 3.141
    
    .word 0x00003e00 # XXXX | 1.5
    
    .word 0x0000e4d2 # XXXX | -1234
    
    .word 0x00004248 # XXXX | 3.141
    
    .word 0x00004100 # XXXX | 2.5
    
    .word 0x0000654e # XXXX | 1358.0
    
    .word 0x00000006 # XXXX | 3.6e-7
    
    .word 0x00007e00 # XXXX | NaN
vref_end: 
    






