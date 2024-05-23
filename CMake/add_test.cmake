# Macro for adding a unit test to run on the verilated model.  
# Unit tests are single assembly files containing data and reference outputs.  These are compared at the end and returns success if they match

# - TEST_PATH_NAME is the folder within test - + name of test (mul/vmacc16.S)
# - TEST_SOURCE_PATH is the path to the top level folder with the sources for the file (.../tests for tests/mul/vmacc16.S)
# - TEST_BUILD_PATH is the path to the folder where all build files and memory dumps will end up

macro(add_unit_test TEST_PATH_NAME TEST_SOURCE_PATH TEST_BUILD_PATH)

    #replace / with - for test name
    string(REPLACE "/" "-" TEST_NAME ${TEST_PATH_NAME})
    string(REPLACE ".S" "" TEST_NAME ${TEST_NAME})

    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${TEST_SOURCE_PATH}
    )

    target_sources(${TEST_NAME} PRIVATE
        ${TEST_SOURCE_PATH}/${TEST_PATH_NAME}
        ${VICUNA_SOURCE_TOP}/test/spill_cache.S
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME} PRIVATE "-nostdlib")
    target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/lld_link.ld")

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE bsp_Vicuna)

    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary ${TEST_NAME}.elf ${TEST_NAME}.bin #Needs to be parameterized in case GCC is used (just use objcopy variable?)
                       COMMAND srec_cat ${TEST_NAME}.bin -binary -offset 0x0000 -byte-swap 4 -o ${TEST_NAME}.vmem -vmem
                       COMMAND rm -f prog_${TEST_NAME}.txt
                       COMMAND echo -n "${TEST_BUILD_PATH}/${TEST_NAME}.vmem ${TEST_BUILD_PATH}/${TEST_NAME}_reference.txt " > prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND echo -n "${TEST_BUILD_PATH}/${TEST_NAME}_result.txt " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt)
	              

    #Add Test
    #Write permissions to create csv log not given to CTest.  Could potentially fix this.  For now, modified verilator_main.cpp to not require path and print out total cycles spent.
    add_test(NAME ${TEST_NAME}
    #COMMAND .${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build/verilated_model ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/prog_${TEST_NAME}.txt 32 262144 1 1024
    COMMAND cmake -DTEST_NAME=${TEST_NAME} -DBUILD_DIR=${TEST_BUILD_PATH} -DVERILATED_DIR=${VERILATED_DIR} -P ${CMAKE_TOP}/run_test.cmake
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..
    )

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()

#Macro for adding a unit test to run with Spike.  
#Unit tests are single assembly files containing data and reference outputs.  This test only runs with spike (no proxy kernel), and generates a signature.  Signature is compared with the output from the test running on Vicuna.  Returns success if both outputs match.  
#Has a dependency on the unit test running on Vicuna

# - TEST_PATH_NAME is the folder within test - + name of test (mul/vmacc16.S)
# - TEST_SOURCE_PATH is the path to the top level folder with the sources for the file (.../tests for tests/mul/vmacc16.S)
# - TEST_BUILD_PATH is the path to the folder where all build files and memory dumps will end up
macro(add_unit_test_spike TEST_PATH_NAME TEST_SOURCE_PATH TEST_BUILD_PATH)

    #replace / with - for test name
    string(REPLACE "/" "-" TEST_NAME ${TEST_PATH_NAME})
    string(REPLACE ".S" "" TEST_NAME ${TEST_NAME})

    add_executable(${TEST_NAME}_Spike)

    target_include_directories(${TEST_NAME}_Spike PRIVATE
        ${TEST_SOURCE_PATH}
    )

    target_sources(${TEST_NAME}_Spike PRIVATE
        ${TEST_SOURCE_PATH}/${TEST_PATH_NAME}
    )

    #Set Linker
    target_link_options(${TEST_NAME}_Spike PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME}_Spike PRIVATE "-nostdlib")
    target_link_options(${TEST_NAME}_Spike PRIVATE "-T${SPIKE_SOURCES_TOP}/sw/link.ld")

    #Link BSP
    target_link_libraries(${TEST_NAME}_Spike PRIVATE Spike_Support)

    #Add the Vicuna Test as a dependency for the Spike test
    add_dependencies(${TEST_NAME}_Spike ${TEST_NAME})
    
    #Need to redefine the symbol names so that spike can output them as a signature
    add_custom_command(TARGET ${TEST_NAME}_Spike
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy --redefine-sym vdata_start=begin_signature --redefine-sym vdata_end=end_signature ${TEST_NAME}_Spike.elf ${TEST_NAME}_Spike.elf)
                      
    #Add Test ##NEED TO PASS THE PROPER RISCV_ARCH.  for spike must translate zve32x to v.  Should also pass vlen/elen?  Vlen shouldnt change outputs, so for my case this doesnt matter?
    add_test(NAME ${TEST_NAME}_Spike
    COMMAND cmake -DTEST_NAME=${TEST_NAME} -DBUILD_DIR=${TEST_BUILD_PATH} -DSPIKE_DIR=${SPIKE_SOURCES_TOP} -P ${CMAKE_TOP}/run_spike_comparison.cmake
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..
    )

    message(STATUS "Successfully added ${TEST_NAME}_Spike")

endmacro()
