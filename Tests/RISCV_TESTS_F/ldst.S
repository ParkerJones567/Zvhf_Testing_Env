#Adapted from RISCV_TESTS : https://github.com/riscv-software-src/riscv-tests/tree/master
#This test contains test cases for flw and fsw



    .text
    .global main
main:
    la              a0, vdata_start
    
    fsflags a1, x0  #Reset fflags
    
    flw f1, 4(a0)
    fsw f1, 20(a0)
    
    flw f1, 0(a0)
    fsw f1, 24(a0)
    

    la              a0, vdata_start
    la              a1, vdata_end
    j               spill_cache  


    .data
    .align 10
    .global vdata_start
    .global vdata_end
vdata_start:
    .word 0xbf800000
    .word 0x40000000
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
    .word 0xbf800000
    .word 0x40000000
    .word 0x40400000
    .word 0xc0800000
    .word 0xdeadbeef
    .word 0x40000000
    .word 0xbf800000
    .word 0x1337d00d
vref_end:




