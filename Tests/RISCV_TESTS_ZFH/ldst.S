#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for flw and fsw



    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    #lower half load, lower half store
    flh f1, 4(a0)
    fsh f1, 20(a0)
    
    #lower half load, upper half store 
    flh f1, 0(a0)
    fsh f1, 22(a0)
    
    #upper half load, lower half store 
    flh f1, 2(a0)
    fsh f1, 16(a0)
    
    #upper half load, upper half store
    flh f1, 6(a0)
    fsh f1, 30(a0)
    
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word 0xbf888888
    .word 0x40001111
    .word 0x40400000
    .word 0xc0800000
    .word 0xdeadbeef
    .word 0xcafebabe
    .word 0xabad1dea
    .word 0x1337d00d
vdata_end: 



    .align 10
    .global vref_start
    .global vref_end
vref_start:
    .word 0xbf888888
    .word 0x40001111
    .word 0x40400000
    .word 0xc0800000
    .word 0xdeadbf88
    .word 0x88881111
    .word 0xabad1dea
    .word 0x4000d00d

vref_end:




