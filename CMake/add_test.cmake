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
    if (${TOOLCHAIN} STREQUAL "LLVM")
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/lld_link.ld")
    else()
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/link.ld")
    endif()
    

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
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objdump -D ${TEST_NAME}.elf > ${TEST_NAME}_dump.txt)
                       
     
    #If trace option is selected, provide the paths for the .csv and .vcd trace files.  Due to argument parsing in verilator_main.cpp, both must be provided                
    if(TRACE)
        set(MEM_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_mem.csv")
        set(VCD_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_sig.vcd")
    else()
        set(MEM_TRACE_ARGS "")
        set(VCD_TRACE_ARGS "")
    endif()
	              

    #Add Test
    add_test(NAME ${TEST_NAME}
             COMMAND cmake -DTEST_NAME=${TEST_NAME} -DBUILD_DIR=${TEST_BUILD_PATH} -DVERILATED_DIR=${VERILATED_DIR} -DMEM_TRACE_ARGS=${MEM_TRACE_ARGS} -DMEM_LATENCY=${MEM_LATENCY} -DVCD_TRACE_ARGS=${VCD_TRACE_ARGS} -P ${CMAKE_TOP}/run_test.cmake
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

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
    target_link_libraries(${TEST_NAME}_Spike PRIVATE Spike_Baremetal_Support)

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


# Macro for adding a small code snippet to run on the verilated model.  
# TEST is the name of the main file holding the code
# SOURCE_DIR is the directory holding this file and any other sources
# These need to include the Vicuna Runtime and UART library
macro(add_code_test_vicuna TEST SOURCE_DIR TEST_BUILD_DIR)


    set(TEST_NAME CODE-${TEST}) #need to add a suffix, ctest doesnt allow 'test' as a test name
    
    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${SOURCE_DIR}
    )

    target_sources(${TEST_NAME} PUBLIC
        ${SOURCE_DIR}/${TEST}.c
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME} PRIVATE "-nostdlib")
    if (${TOOLCHAIN} STREQUAL "LLVM")
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/lld_link.ld")
    else()
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/link.ld")
    endif()

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE bsp_Vicuna UART_Vicuna)

    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary ${TEST_NAME}.elf ${TEST_NAME}.bin #Needs to be parameterized in case GCC is used (just use objcopy variable?)
                       COMMAND srec_cat ${TEST_NAME}.bin -binary -offset 0x0000 -byte-swap 4 -o ${TEST_NAME}.vmem -vmem
                       COMMAND rm -f prog_${TEST_NAME}.txt
                       COMMAND echo -n "${TEST_BUILD_DIR}/${TEST_NAME}.vmem" > prog_${TEST_NAME}.txt
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objdump -D ${TEST_NAME}.elf > ${TEST_NAME}_dump.txt)
                       
    if(TRACE)
        set(MEM_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_mem.csv")
        set(VCD_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_sig.vcd")
    else()
        set(MEM_TRACE_ARGS "")
        set(VCD_TRACE_ARGS "")
    endif()
             
                       
	              

    #Add Test
    add_test(NAME ${TEST_NAME} 
             COMMAND ./${VERILATED_DIR}/verilated_model ${TEST_BUILD_DIR}/prog_${TEST_NAME}.txt 32 4194304 ${MEM_LATENCY} 1 ${MEM_TRACE_ARGS} ${VCD_TRACE_ARGS} #TODO: PASS THESE ARGUMENTS IN FROM USER
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()

macro(add_Benchmark_Vicuna TEST SOURCE_DIR TEST_BUILD_DIR)

    set(TEST_NAME ${TEST}) #need to add a suffix, ctest doesnt allow 'test' as a test name
    
    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${SOURCE_DIR}
        ${SOURCE_DIR}/model_data
    )

    target_sources(${TEST_NAME} PUBLIC
        ${SOURCE_DIR}/${TEST}.cpp
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.h
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    if (${TOOLCHAIN} STREQUAL "LLVM")
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/lld_link.ld")
    else()
        target_link_options(${TEST_NAME} PRIVATE "-T${VICUNA_SOURCE_TOP}/sw/link.ld")
    endif()

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE bsp_Vicuna UART_Vicuna tflm)

    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary ${TEST_NAME}.elf ${TEST_NAME}.bin #Needs to be parameterized in case GCC is used (just use objcopy variable?)
                       COMMAND srec_cat ${TEST_NAME}.bin -binary -offset 0x0000 -byte-swap 4 -o ${TEST_NAME}.vmem -vmem
                       COMMAND rm -f prog_${TEST_NAME}.txt
                       COMMAND echo -n "${TEST_BUILD_DIR}/${TEST_NAME}.vmem" > prog_${TEST_NAME}.txt
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objdump -D ${TEST_NAME}.elf > ${TEST_NAME}_dump.txt)
    
    #VERY DANGEROUS TO USE TRACE                   
    if(TRACE)
        set(MEM_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_mem.csv")
        set(VCD_TRACE_ARGS "${BUILD_DIR}/Testing/last_test_sig.vcd")
    else()
        set(MEM_TRACE_ARGS "")
        set(VCD_TRACE_ARGS "")
    endif()
                       
	              

    #Add Test
    add_test(NAME ${TEST_NAME} 
             COMMAND ./${VERILATED_DIR}/verilated_model ${TEST_BUILD_DIR}/prog_${TEST_NAME}.txt 32 4194304 ${MEM_LATENCY} 1 ${MEM_TRACE_ARGS} ${VCD_TRACE_ARGS}  #TODO: PASS THESE ARGUMENTS IN FROM USER
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)
             
    set_tests_properties(${TEST_NAME} PROPERTIES TIMEOUT 0) #TODO: Find a reasonable timeout for these tests

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()

macro(add_Benchmark_Spike TEST SOURCE_DIR TEST_BUILD_DIR)

    set(TEST_NAME ${TEST}_Spike) #need to add a suffix, ctest doesnt allow 'test' as a test name
    
    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${SOURCE_DIR}
        ${SOURCE_DIR}/model_data
    )

    target_sources(${TEST_NAME} PUBLIC
        ${SOURCE_DIR}/${TEST}.cpp
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.h
        ${SOURCE_DIR}/../../../Spike/sw/baremetal/spike_cycle_out.S
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME} PRIVATE "-static")
    target_link_options(${TEST_NAME} PRIVATE "-static-libgcc")
    target_link_options(${TEST_NAME} PRIVATE "-static-libstdc++")
    target_link_options(${TEST_NAME} PRIVATE "-T${SPIKE_SOURCES_TOP}/sw/link.ld")

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE Spike_Baremetal_Support tflm)  
    
    #Need to redefine the symbol names so that spike can output them as a signature
    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy --redefine-sym vdata_start=begin_signature --redefine-sym vdata_end=end_signature ${TEST_NAME}.elf ${TEST_NAME}.elf) 
    
    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objdump -D ${TEST_NAME}.elf > ${TEST_NAME}_dump.txt)     	              

    #Add Test
    add_test(NAME ${TEST_NAME} 
             COMMAND ${SPIKE_SOURCES_TOP}/spike --isa=rv32imf_zicntr_zihpm_zve32f_zvl512b_zvfh +signature=${TEST_BUILD_DIR}/${TEST_NAME}_inst_count.txt --signature=${TEST_BUILD_DIR}/${TEST_NAME}_inst_count.txt +signature-granularity=4 --signature-granularity=4 ${TEST_BUILD_DIR}/${TEST_NAME}.elf
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()



macro(add_Benchmark_Spike_PK TEST SOURCE_DIR TEST_BUILD_DIR)

    set(TEST_NAME ${TEST}_Spike_PK)
    
    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${SOURCE_DIR}
        ${SOURCE_DIR}/model_data
    )

    target_sources(${TEST_NAME} PRIVATE
        ${SOURCE_DIR}/${TEST}.cpp
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_input_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_data.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_model_settings.h
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.cc
        ${SOURCE_DIR}/${TEST}_data/${TEST}_output_data_ref.h
    )

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE tflm Spike_PK_Support)   
    
    #add_custom_command(TARGET ${TEST_NAME}
    #                  POST_BUILD
    #                   COMMAND ${RISCV_LLVM_PREFIX}/llvm-objdump -D ${TEST_NAME}.elf > ${TEST_NAME}_dump.txt)     	              

    #Add Test
    add_test(NAME ${TEST_NAME} 
             COMMAND ${SPIKE_SOURCES_TOP}/spike --isa=rv32imf_zicntr_zihpm_zve32f_zvl128b_zvfh ${SPIKE_SOURCES_TOP}/pk_ilp32 ${TEST_BUILD_DIR}/${TEST_NAME}.elf
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()





