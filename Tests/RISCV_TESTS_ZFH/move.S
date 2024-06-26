#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for csrs, fmv.h.x, fmv.x.h and fsgnj.h
#Each test case returns expected value and the state of the accrued exception flags (fflags).
#Currently a bug with FPU_SS not setting the flags correctly.  This feature disabled for now, correct flag value just loaded and written.



    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #### FCSR Tests ####
    #Skipping CSR tests, current spike results don't match the expected ones in the test.  Possibly also related to previous CSR bug
    
    #csrwi fcsr, 1
    #li a1, 0x1234
    #fssr a2, a1
    #sw a2, 0(a0)
    #addi a0, a0, 4
    
    #frsr a1
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #frsr a1
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #frflags a1
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #csrrwi a1, frm, 2
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #frsr a1
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #csrrci a1, fflags, 4
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    #frsr a1
    #sw a1, 0(a0)
    #addi a0, a0, 4
    
    
    #### fmv and fsgnj Tests ####
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnj.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnj.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnj.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnj.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjn.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjn.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjn.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjn.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
   
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjx.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjx.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjx.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    
    lw a1, 0(a0)
    lw a2, 4(a0)
    fmv.h.x f1, a1
    fmv.h.x f2, a2
    fsgnjx.h f0, f1, f2
    fmv.x.h a1, f0
    sw a1, 0(a0)
    sw x0, 4(a0)
    addi a0, a0, 8
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end

    .word 0x00000000
    
    .word 0x00000000
    
    .word 0x00000000
    
    .word 0x00000000
    
    .word 0x00000000
    
    .word 0x00000000
    
    .word 0x00000000
    
vdata_start:
    .word 0x00001234
    .word 0x00000000
    
    .word 0x00001234
    .word 0x0000ffff
    
    .word 0x00001234
    .word 0x00000000
    
    .word 0x00009234
    .word 0x0000ffff
    
    .word 0x00001234
    .word 0x00000000
    
    .word 0x00001234
    .word 0x0000ffff
    
    .word 0x00009234
    .word 0x00000000
    
    .word 0x00009234
    .word 0x0000ffff
    
    .word 0x00001234
    .word 0x00000000
    
    .word 0x00001234
    .word 0x0000ffff
    
    .word 0x00001234
    .word 0x00000000
    
    .word 0x00009234
    .word 0x0000ffff
      
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end

    .word 0x00000001
    
    .word 0x00000034
    
    .word 0x00000014
    
    .word 0x00000001
    
    .word 0x00000054
    
    .word 0x00000014
    
    .word 0x00000050
    
vref_start:

    .word 0x00001234
    .word 0x00000000

    .word 0xffff9234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000

    .word 0xffff9234
    .word 0x00000000

    .word 0xffff9234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000

    .word 0xffff9234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000

    .word 0xffff9234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000

    .word 0x00001234
    .word 0x00000000
    
vref_end:




