#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fmin.h and fmax.h
#Each test case returns expected value and TODO(state of the accrued exception flags (fflags).)

    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fmin.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    #### fmax.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    # FMAX(sNaN, x) = x
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    # FMAX(qNaN, qNaN) = canonical NaN
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    # -0.0 < +0.0
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmin.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
    sw x0, 0(a0)
    fsh f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    fmax.h f31, f0, f1
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
    
    .word 0x3c004100 # 1.0 | 2.5
    
    .word 0x3c66e4d3 # 1.1 | -1235.1
    
    .word 0xe4d33c66 # -1235.1 | 1.1
    
    .word 0xe4d37e00 # -1235.1 | NaN
    
    .word 0x00024248 # 0.0000001 | 3.1415
    
    .word 0xc000bc00 # -2.0 | -1.0
    
    .word 0x3c004100 # 1.0 | 2.5
    
    .word 0x3c66e4d3 # 1.1 | -1235.1
    
    .word 0xe4d33c66 # -1235.1 | 1.1
    
    .word 0xe4d37e00 # -1235.1 | NaN
    
    .word 0x00024248 # 0.0000001 | 3.1415
    
    .word 0xc000bc00 # -2.0 | -1.0
    
    .word 0x7c013c00 # sNaN | 1.0
    
    .word 0x7e007e00 # NaN | NaN
    
    .word 0x00008000 # 0 | -0
    
    .word 0x80000000 # -0 | 0
    
    .word 0x00008000 # 0 | -0
    
    .word 0x80000000 # -0 | 0 

vdata_end:


    .align 10
    .global vref_start
    .global vref_end
vref_start:

    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x0000e4d3 # XXXX | -1235.1
    
    .word 0x0000e4d3 # XXXX | -1235.1
    
    .word 0x0000e4d3 # XXXX | -1235.1
    
    .word 0x00000002 # XXXX | 0.0000001
    
    .word 0x0000c000 # XXXX | -2.0
    
    .word 0x00004100 # XXXX | 2.5
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0x0000e4d3 # XXXX | -1235.1
    
    .word 0x00004248 # XXXX | 3.1415
    
    .word 0x0000bc00 # XXXX | -1.0
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x00007e00 # XXXX | NaN
    
    .word 0x00008000 # XXXX | -0
    
    .word 0x00008000 # XXXX | -0
    
    .word 0x00000000 # XXXX | 0
    
    .word 0x00000000 # XXXX | 0
  
vref_end:



