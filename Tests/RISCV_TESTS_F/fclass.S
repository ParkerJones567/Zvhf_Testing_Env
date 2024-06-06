#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fclass.s.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### arithmetic tests ####
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flw f0, 0(a0)
    fclass.s a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    

    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float           -inf
    
    .float           -1.0
    
    .float           -1.1754942e-38
    
    .float           -0
    
    .float           0
    
    .float           1.1754942e-38
    
    .float           1.0
    
    .float           inf
    
    .word            0x7f800001 #NaN
    
    .word            0x7fc00000 #NaN
vdata_end:


    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word           0x00000001
    
    .word           0x00000002
    
    .word           0x00000004
    
    .word           0x00000008
    
    .word           0x00000010
    
    .word           0x00000020
    
    .word           0x00000040
    
    .word           0x00000080
    
    .word           0x00000100
    
    .word           0x00000200

vref_end:



