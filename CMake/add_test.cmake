#Macro for adding a Vicuna unit test (assembly only tests located under Vicuna's test/ directory) 
#TEST_PATH_NAME is the folder within test - + name of test (mul/vmacc16.S)
#include(${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake)

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
                       COMMAND echo -n "${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/${TEST_NAME}.vmem ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/${TEST_NAME}_reference.txt " > prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND echo -n "${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/${TEST_NAME}_result.txt " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt)
	              

    #Add Test
    #Write permissions to create csv log not given to CTest.  Could potentially fix this.  For now, modified verilator_main.cpp to not require path and print out total cycles spent.
    add_test(NAME ${TEST_NAME}
    #COMMAND .${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build/verilated_model ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Vicuna/prog_${TEST_NAME}.txt 32 262144 1 1024
    COMMAND cmake -DTEST_NAME=${TEST_NAME} -DBUILD_DIR=${BUILD_DIR}/Vicuna -DVERILATED_DIR=${VERILATED_DIR} -P ${CMAKE_CURRENT_SOURCE_DIR}/../CMake/run_test.cmake
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..
    )

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()

#macro to add custom test 
macro(add_unit_test TEST_PATH_NAME)

    #replace / with - for test name
    string(REPLACE "/" "-" TEST_NAME ${TEST_PATH_NAME})
    string(REPLACE ".S" "" TEST_NAME ${TEST_NAME})

    add_executable(${TEST_NAME})

    target_include_directories(${TEST_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/FPU
    )

    target_sources(${TEST_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/${TEST_PATH_NAME}
        ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/test/spill_cache.S
    )

    #Set Linker
    target_link_options(${TEST_NAME} PRIVATE "-nostartfiles")
    target_link_options(${TEST_NAME} PRIVATE "-nostdlib")

    #Link BSP
    target_link_libraries(${TEST_NAME} PRIVATE bsp_Vicuna)
    

    #Create the vmem file and the file with the path to the .vmem file and the start/end addresses of the reference and result data
    add_custom_command(TARGET ${TEST_NAME}
                       POST_BUILD
                       COMMAND ${RISCV_LLVM_PREFIX}/llvm-objcopy -O binary ${TEST_NAME}.elf ${TEST_NAME}.bin #Needs to be parameterized in case GCC is used (just use objcopy variable?)
                       COMMAND srec_cat ${TEST_NAME}.bin -binary -offset 0x0000 -byte-swap 4 -o ${TEST_NAME}.vmem -vmem
                       COMMAND rm -f prog_${TEST_NAME}.txt
                       COMMAND echo -n "${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Tests/${TEST_NAME}.vmem ${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Tests/${TEST_NAME}_reference.txt " > prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vref_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND echo -n "${CMAKE_CURRENT_SOURCE_DIR}/../build_programs/build/Tests/${TEST_NAME}_result.txt " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_start | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt
                       COMMAND readelf -s ${TEST_NAME}.elf | sed '2,13 s/ //1' | grep vdata_end | cut -d " " -f 6 | tr [=["\n"]=] " " >> prog_${TEST_NAME}.txt)
                       
	              

    #Add Test
    #Write permissions to create csv log not given to CTest.  Could potentially fix this.  For now, modified verilator_main.cpp to not require path and print out total cycles spent.
    add_test(NAME ${TEST_NAME}
             COMMAND cmake -DTEST_NAME=${TEST_NAME} -DBUILD_DIR=${BUILD_DIR}/Tests -DVERILATED_DIR=${VERILATED_DIR} -P ${CMAKE_CURRENT_SOURCE_DIR}/../CMake/run_test.cmake
             WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../..)

    message(STATUS "Successfully added ${TEST_NAME}")

endmacro()
