####
# Include file with macros for adding tests
####
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/add_test.cmake)


####
#Add bsp library for Vicuna
####
add_library(bsp_Vicuna STATIC)

target_include_directories(bsp_Vicuna PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/
)

target_sources(bsp_Vicuna PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/crt0.S  
)


####
#Add Validation Tests (TODO: Ones currently in Vicuna repo use the old Vector Intrinsics, update them and add a macro to easily add them)
####



#hello-world test
#add_executable(test-v)

#Test sources
#target_include_directories(test-v PRIVATE
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/docs/code
#)

#target_sources(test-v PRIVATE
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/docs/code/test.c
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/runtime.c
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/runtime.h
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/uart.c
#  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/uart.h
#)


#target_link_options(test-v PRIVATE "-nostartfiles")
#target_link_options(test-v PRIVATE "-nostdlib")

#Link BSP
#target_link_libraries(test-v PRIVATE bsp_Vicuna)

#add_custom_command(TARGET test-v
#                   POST_BUILD
#                   COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary test-v.elf test-v.bin       #Needs to be parameterized in case GCC is used (just use objcopy variable?)
#                   COMMAND srec_cat test-v.bin -binary -offset 0x0000 -byte-swap 4 -o test-v.vmem -vmem
#                   COMMAND rm -f prog_test-v.txt
#                   COMMAND echo ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/test-v.vmem >> prog_test-v.txt)
	               

#Add Test
#add_test(NAME test-v
#COMMAND .${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build/verilated_model ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/prog_test-v.txt 32 262144 1 1024
#WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)



#### Add all unit tests in vicuna/test directory if Zve32x is enabled ####
#### Each test is a single, separate assembly file ####

# Path to linker scripts for Vicuna and Spike Tests
set(CMAKE_EXE_LINKER_FLAGS_VICUNA "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lld_link.ld")
set(CMAKE_EXE_LINKER_FLAGS_SPIKE "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_CURRENT_SOURCE_DIR}/../Spike/sw/link.ld")


if(USE_ZVE32X)

    file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/*/*.S")
    foreach(file ${files})
        #set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS_VICUNA})
        #Get name of the test
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/" "" TEST_PATH ${file})
        add_unit_test(${TEST_PATH} "${VICUNA_SOURCE_TOP}/test/" "${BUILD_DIR}/Vicuna/")
    endforeach()
    
    if(SPIKE)
        
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/*/*.S")
        foreach(file ${files})
            #set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS_SPIKE})
            #Get name of the test
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/" "" TEST_PATH ${file})
            add_unit_test_spike(${TEST_PATH} "${VICUNA_SOURCE_TOP}/test/" "${BUILD_DIR}/Vicuna/")
        endforeach()
    
    
    endif()
    
    
endif()
    


