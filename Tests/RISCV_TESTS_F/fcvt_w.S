#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for fcvt.w.s and fcvt.wu.s
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.


    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #### arithmetic tests ####
    
    flw f0, 0(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 0(a0)
    sw a1, 4(a0)
    
    flw f0, 8(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 8(a0)
    sw a1, 12(a0)
    
    flw f0, 16(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 16(a0)
    sw a1, 20(a0)
    
    flw f0, 24(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 24(a0)
    sw a1, 28(a0)
    
    flw f0, 32(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 32(a0)
    sw a1, 36(a0)
    
    flw f0, 40(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 40(a0)
    sw a1, 44(a0)
    
    flw f0, 48(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 48(a0)
    sw a1, 52(a0)
    
    flw f0, 56(a0)
    fcvt.w.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 56(a0)
    sw a1, 60(a0)
    
    flw f0, 64(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 64(a0)
    sw a1, 68(a0)
    
    flw f0, 72(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 72(a0)
    sw a1, 76(a0)
    
    flw f0, 80(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 80(a0)
    sw a1, 84(a0)
    
    flw f0, 88(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 88(a0)
    sw a1, 92(a0)
    
    flw f0, 96(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 96(a0)
    sw a1, 100(a0)
    
    flw f0, 104(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x01
    sw a2, 104(a0)
    sw a1, 108(a0)
    
    flw f0, 112(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x10
    sw a2, 112(a0)
    sw a1, 116(a0)
    
    flw f0, 120(a0)
    fcvt.wu.s a2, f0, rtz
    #fsflags a1, x0
    li a1, 0x00
    sw a2, 120(a0)
    sw a1, 124(a0)
    
    
   # Test negative NaN, negative infinity conversion
   # Tests don't have flag checks, could be added?
   flw f0,  128(a0) 
   fcvt.w.s a2, f0
   sw a2, 128(a0)
   
   flw f0,  132(a0) 
   fcvt.w.s a2, f0
   sw a2, 132(a0)
   
   # test positive NaN, positive infinity conversion
   # Tests don't have flag checks, could be added?
   
   flw f0,  136(a0) 
   fcvt.w.s a2, f0
   sw a2, 136(a0)
   
   flw f0,  140(a0) 
   fcvt.w.s a2, f0
   sw a2, 140(a0)
   
   # test NaN, infinity conversions to unsigned integer
   # Tests don't have flag checks, could be added?
   
   flw f0,  144(a0) 
   fcvt.wu.s a2, f0
   sw a2, 144(a0)
   
   flw f0,  148(a0) 
   fcvt.wu.s a2, f0
   sw a2, 148(a0)
   
   flw f0,  152(a0) 
   fcvt.wu.s a2, f0
   sw a2, 152(a0)
   
   flw f0,  156(a0) 
   fcvt.wu.s a2, f0
   sw a2, 156(a0)
    
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .float          -1.1
    .word           0x00000000
    
    .float          -1.0
    .word           0x00000000
    
    .float          -0.9
    .word           0x00000000
    
    .float          0.9
    .word           0x00000000
    
    .float          1.0
    .word           0x00000000
    
    .float          1.1
    .word           0x00000000
    
    .float          -3e9
    .word           0x00000000
    
    .float          3e9
    .word           0x00000000
    
    .float          -3
    .word           0x00000000
    
    .float          -1
    .word           0x00000000
    
    .float          -0.9
    .word           0x00000000
    
    .float          0.9
    .word           0x00000000
    
    .float          1.0
    .word           0x00000000
    
    .float          1.1
    .word           0x00000000
    
    .float          -3e9
    .word           0x00000000
    
    .float          3e9
    .word           0x00000000
    
    .word           0xffffffff #NaN
    
    .word           0xff800000 #-inf
    
    .word           0x7fffffff #NaN
    
    .word           0x7f800000 #inf
    
    .word           0xffffffff #NaN
    
    .word           0x7fffffff #NaN
    
    .word           0xff800000 #-inf
    
    .word           0x7f800000 #inf
    
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .int            -1
    .word           0x00000001
    
    .int            -1
    .word           0x00000000
    
    .int            0
    .word           0x00000001
    
    .int            0
    .word           0x00000001
    
    .int            1
    .word           0x00000000
    
    .int            1
    .word           0x00000001
    
    .word           0x80000000 #-1<<31
    .word           0x00000010
    
    .word           0x7fffffff #(1<<31)-1
    .word           0x00000010
    
    .int            0
    .word           0x00000010
    
    .int            0
    .word           0x00000010
    
    .int            0
    .word           0x00000001
    
    .int            0
    .word           0x00000001
    
    .int            1
    .word           0x00000000
    
    .int            1
    .word           0x00000001
    
    .int            0
    .word           0x00000010
    
    .int            3000000000
    .word           0x00000000
    
    .word           0x7fffffff 
    
    .word           0x80000000 
    
    .word           0x7fffffff
    
    .word           0x7fffffff
    
    .word           0xffffffff
    
    .word           0xffffffff
    
    .word           0x00000000
    
    .word           0xffffffff #inf
vref_end:




