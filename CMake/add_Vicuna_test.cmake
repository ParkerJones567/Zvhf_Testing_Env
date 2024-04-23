#Macro for adding a Vicuna unit test (assembly only tests located under Vicuna's test/ directory) 
#TEST_PATH_NAME is the folder within test - + name of test (mul/vmacc16.S)

macro(add_vicuna_unit_test TEST_PATH_NAME)

    #replace / with - for test name
    string(REPLACE "/" "-" TEST_NAME ${TEST_PATH_NAME})
    string(REPLACE ".S" "" TEST_NAME ${TEST_NAME})

    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test
    )

    target_sources(${TEST_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/${TEST_PATH_NAME}
        ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/spill_cache.S
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME} PRIVATE "-nostdlib")

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE bsp_Vicuna)

    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary ${TEST_NAME}.elf ${TEST_NAME}.bin #Needs to be parameterized in case GCC is used (just use objcopy variable?)
                       COMMAND srec_cat ${TEST_NAME}.bin -binary -offset 0x0000 -byte-swap 4 -o ${TEST_NAME}.vmem -vmem
                       COMMAND rm -f prog_${TEST_NAME}.txt
                       COMMAND echo ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/${TEST_NAME}.vmem >> prog_${TEST_NAME}.txt) #Put relative path
	              

    #Add Test
    #Write permissions to create csv log not given to CTest.  Could potentially fix this.  For now, modified verilator_main.cpp to not require path and print out total cycles spent.
    add_test(NAME ${TEST_NAME}
    COMMAND .${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build/verilated_model ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/prog_${TEST_NAME}.txt 32 262144 1 1024
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()
