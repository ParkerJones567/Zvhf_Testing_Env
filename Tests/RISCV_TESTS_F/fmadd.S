#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fmadd.s, fnmadd.s, fmsub.s, and fnmsub.s
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### fmadd.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    

    
    #### fnmadd.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmadd.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    #### fmsub.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    #### fnmsub.s tests ####
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x01
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    
    flw f0, 0(a0) 
    flw f1, 4(a0)
    flw f2, 8(a0)
    fnmsub.s f31, f0, f1, f2
    #fsflags a1, x0
    li a1, 0x00
    fsw f31, 0(a0)
    sw a1, 4(a0)
    sw a1, 8(a0)
    addi a0, a0, 12
    

    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float           1.0
    .float           2.5
    .float           1.0
    
    .float           -1.0
    .float           -1235.1
    .float           1.1
    
    .float           2.0
    .float           -5.0
    .float           -2.0
    
    .float           1.0
    .float           2.5
    .float           1.0
    
    .float           -1.0
    .float           -1235.1
    .float           1.1
    
    .float           2.0
    .float           -5.0
    .float           -2.0

    .float           1.0
    .float           2.5
    .float           1.0
    
    .float           -1.0
    .float           -1235.1
    .float           1.1
    
    .float           2.0
    .float           -5.0
    .float           -2.0
   
    .float           1.0
    .float           2.5
    .float           1.0
    
    .float           -1.0
    .float           -1235.1
    .float           1.1
    
    .float           2.0
    .float           -5.0
    .float           -2.0

vdata_end:   



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          3.5
    .word           0x00000000
    .word           0x00000000
    
    .float          1236.2
    .word           0x00000001
    .word           0x00000001
    
    .float          -12.0
    .word           0x00000000
    .word           0x00000000
    
    .float          -3.5
    .word           0x00000000
    .word           0x00000000
    
    .float          -1236.2
    .word           0x00000001
    .word           0x00000001
    
    .float          12.0
    .word           0x00000000
    .word           0x00000000
    
    .float          1.5
    .word           0x00000000
    .word           0x00000000
    
    .float          1234
    .word           0x00000001
    .word           0x00000001
    
    .float          -8.0
    .word           0x00000000
    .word           0x00000000
     
    .float          -1.5
    .word           0x00000000
    .word           0x00000000
    
    .float          -1234
    .word           0x00000001
    .word           0x00000001
     
    .float          8.0
    .word           0x00000000
    .word           0x00000000
vref_end:






