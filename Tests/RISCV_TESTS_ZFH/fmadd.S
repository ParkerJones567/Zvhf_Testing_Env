#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fmadd.h, fnmadd.h, fmsub.h, and fnmsub.h
#Each test case returns expected value and TODO(state of the accrued exception flags (fflags).)


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fmadd.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    

    
    #### fnmadd.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmadd.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    #### fmsub.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    #### fnmsub.h tests ####
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    
    flh f0, 0(a0) 
    flh f1, 2(a0)
    flh f2, 4(a0)
    fnmsub.h f31, f0, f1, f2
    sw x0, 0(a0)
    sw x0, 4(a0)
    fsh f31, 0(a0)
    addi a0, a0, 8
    

    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:

    .word 0x41003c00 # 2.5 | 1.0
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0xe4d3bc00 # -1235.1 | -1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0xc5004000 # -5.0 | 2.0
    
    .word 0x0000c000 # XXXX | -2.0
    
    .word 0x41003c00 # 2.5 | 1.0
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0xe4d3bc00 # -1235.1 | -1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0xc5004000 # -5.0 | 2.0
    
    .word 0x0000c000 # XXXX | -2.0
    
    .word 0x41003c00 # 2.5 | 1.0
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0xe4d3bc00 # -1235.1 | -1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0xc5004000 # -5.0 | 2.0
    
    .word 0x0000c000 # XXXX | -2.0
    
    .word 0x41003c00 # 2.5 | 1.0
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0xe4d3bc00 # -1235.1 | -1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0xc5004000 # -5.0 | 2.0
    
    .word 0x0000c000 # XXXX | -2.0

vdata_end:   



    .align 10
    .global vref_start
    .global vref_end
vref_start:

    .word 0x00004300 # XXXX | 3.5
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x000064d4 # XXXX | 1236.2
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000ca00 # XXXX | -12.0
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000c300 # XXXX | -3.5
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000e4d4 # XXXX | -1236.2
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x00004a00 # XXXX | 12.0
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x00003e00 # XXXX | 1.5
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x000064d2 # XXXX | 1234.0
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000c800 # XXXX | -8.0
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000be00 # XXXX | -1.5
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x0000e4d2 # XXXX | -1234.0
    .word 0x00000000 # XXXX | XXXX
    
    .word 0x00004800 # XXXX | 8.0
    .word 0x00000000 # XXXX | XXXX

vref_end:






