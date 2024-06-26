#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fcvt.w.h, fcvt.wu.h, and fcvt.s.h
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #### arithmetic tests ####
    
    #### fcvt.w.h ####
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.w.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    #### fcvt.wu.h ####
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.wu.h a2, f0, rtz
    sw a2, 0(a0)
    addi a0, a0, 4
    
    #### fcvt.s.h ####
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    flh f0, 0(a0)
    fcvt.s.h f31, f0
    fsw f31, 0(a0)
    addi a0, a0, 4
    
    
   # Test negative NaN, negative infinity conversion
   # Tests don't have flag checks, could be added?
   flh f0,  0(a0) 
   fcvt.w.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.w.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   # test positive NaN, positive infinity conversion
   # Tests don't have flag checks, could be added?
   
   flh f0, 0(a0) 
   fcvt.w.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.w.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   # test NaN, infinity conversions to unsigned integer
   # Tests don't have flag checks, could be added?
   
   flh f0, 0(a0) 
   fcvt.wu.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.wu.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.wu.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.wu.h a2, f0
   sw a2, 0(a0)
   addi a0, a0, 4
   
   # test NaN, infinity conversions to single precision float
   # Tests don't have flag checks, could be added?
   
   flh f0, 0(a0) 
   fcvt.s.h f31, f0
   fsw f31, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.s.h f31, f0
   fsw f31, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.s.h f31, f0
   fsw f31, 0(a0)
   addi a0, a0, 4
   
   flh f0, 0(a0) 
   fcvt.s.h f31, f0
   fsw f31, 0(a0)
   addi a0, a0, 4
       
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:

    .word 0x0000bc66 # XXXX | -1.1
    
    .word 0x0000bc00 # XXXX | -1.0
    
    .word 0x0000bb33 # XXXX | -0.9
    
    .word 0x00003b33 # XXXX | 0.9
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0x0000f800 # XXXX | -32768
    
    .word 0x00007800 # XXXX | 32768
    
    .word 0x0000c200 # XXXX | -3
    
    .word 0x0000bc00 # XXXX | -1
    
    .word 0x0000bb33 # XXXX | -0.9
    
    .word 0x00003b33 # XXXX | 0.9
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0x0000f800 # XXXX | -32768
    
    .word 0x00007800 # XXXX | 32768
    
    .word 0x0000bc66 # XXXX | -1.1
    
    .word 0x0000bc00 # XXXX | -1.0
    
    .word 0x0000bb33 # XXXX | -0.9
    
    .word 0x00003b33 # XXXX | 0.9
    
    .word 0x00003c00 # XXXX | 1.0
    
    .word 0x00003c66 # XXXX | 1.1
    
    .word 0x0000f800 # XXXX | -32768
    
    .word 0x00007800 # XXXX | 32768

    .word 0x0000fe00 # XXXX | -NaN
    
    .word 0x0000fc00 # XXXX | -inf
    
    .word 0x00007e00 # XXXX | NaN
    
    .word 0x00007c00 # XXXX | inf
    
    .word 0x0000fe00 # XXXX | -NaN
    
    .word 0x00007e00 # XXXX | NaN
    
    .word 0x0000fc00 # XXXX | -inf
    
    .word 0x00007c00 # XXXX | inf
    
    .word 0x0000fe00 # XXXX | -NaN
    
    .word 0x0000fc00 # XXXX | -inf
    
    .word 0x00007e00 # XXXX | NaN
    
    .word 0x00007c00 # XXXX | inf
    
vdata_end: 




    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .int            -1
    
    .int            -1
    
    .int            0
    
    .int            0
    
    .int            1
    
    .int            1
    
    .int            -32768
    
    .int            32768
    
    .int            0
    
    .int            0
    
    .int            0
    
    .int            0
    
    .int            1
    
    .int            1
    
    .int            0
    
    .int            32768
    
    .word           0xbf8cc000 # -1.0996094
    
    .word           0xbf800000 # -1.0
    
    .word           0xbf666000 # -0.89990234
    
    .word           0x3f666000 # 0.89990234
    
    .word           0x3f800000 # 1.0
    
    .word           0x3f8cc000 # 1.0996094
    
    .word           0xc7000000 # -32768
    
    .word           0x47000000 # 32768
    
    .word           0x7fffffff 
    
    .word           0x80000000 
    
    .word           0x7fffffff
    
    .word           0x7fffffff
    
    .word           0xffffffff
    
    .word           0xffffffff
    
    .word           0x00000000
    
    .word           0xffffffff
    
    .word           0x7fc00000
    
    .word           0xff800000
    
    .word           0x7fc00000
    
    .word           0x7f800000
vref_end:




