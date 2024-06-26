#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fcvt.h.w, fcvt.h.wu, and fcvt.h.s


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    lw a2, 0(a0)
    fcvt.h.w f0, a2
    sw x0, 0(a0)
    fsh f0, 0(a0)
    addi a0, a0, 4
    
    lw a2, 0(a0)
    fcvt.h.w f0, a2
    sw x0, 0(a0)
    fsh f0, 0(a0)  
    addi a0, a0, 4 
    
    lw a2, 0(a0)
    fcvt.h.wu f0, a2
    sw x0, 0(a0)
    fsh f0, 0(a0)
    addi a0, a0, 4
    
    lw a2, 0(a0)
    fcvt.h.wu f0, a2
    sw x0, 0(a0)
    fsh f0, 0(a0)
    addi a0, a0, 4
    
    flw f1, 0(a0)
    fcvt.h.s f0, f1
    sw x0, 0(a0)
    fsh f0, 0(a0)
    addi a0, a0, 4
    
    flw f1, 0(a0)
    fcvt.h.s f0, f1
    sw x0, 0(a0)
    fsh f0, 0(a0)
    addi a0, a0, 4
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .int           2
    
    .int           -2
    
    .int           2
   
    .word          0x0000FFE0 # -32 stored in 16 bit int, when converting unsigned int to half float, any values in the upper half word cause overflow to infinity
  
    .float         2.0
    
    .float         -2.0
vdata_end:  



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word 0x00004000 # XXXX | 2.0
    
    .word 0x0000c000 # XXXX | -2.0
    
    .word 0x00004000 # XXXX | 2.0
  
    .word 0x00007bff # XXXX | 65504
   
    .word 0x00004000 # XXXX | 2.0
    
    .word 0x0000c000 # XXXX | -2.0
vref_end:  





