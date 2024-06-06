#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fcvt.s.w and fcvt.s.wu


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    lw a2, 0(a0)
    fcvt.s.w f0, a2
    fsflags x0
    fsw f0, 0(a0)
    addi a0, a0, 4
    
    lw a2, 0(a0)
    fcvt.s.w f0, a2
    fsflags x0
    fsw f0, 0(a0)  
    addi a0, a0, 4 
    
    lw a2, 0(a0)
    fcvt.s.wu f0, a2
    fsflags x0
    fsw f0, 0(a0)
    addi a0, a0, 4
    
    lw a2, 0(a0)
    fcvt.s.wu f0, a2
    fsflags x0
    fsw f0, 0(a0)
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
    
    .int           -2
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .float          2.0
    
    .float          -2.0
    
    .float          2.0
    
    .float          4.2949673e9
vref_end:




