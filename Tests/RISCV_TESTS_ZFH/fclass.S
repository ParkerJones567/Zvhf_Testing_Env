#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fclass.h.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    
    #### arithmetic tests ####
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
    sw a1, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fclass.h a1, f0
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

    .word 0x0000fc00 # XXXX | -inf

    .word 0x0000bc00 # XXXX | -1.0
    
    .word 0x00008054 # XXXX | -0.000005
   
    .word 0x00008000 # XXXX | -0.0
   
    .word 0x00000000 # XXXX | 0.0
     
    .word 0x00000054 # XXXX | 0.000005
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x00007c00 # XXXX | +inf
    
    .word 0x00007c01 # XXXX | sNaN
    
    .word 0x00007e00 # XXXX | qNaN
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




