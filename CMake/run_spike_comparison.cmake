#Script to run the tests and compare the outputs  Add_test only allows a single command, so this script does the comparison with expected outputs
#All variables must be passed in from the Add_Tests COMMAND argument
#For reuse, provide the direct path to the files for SPIKE_DIR and BUILD_DIR
execute_process(COMMAND ${SPIKE_DIR}/spike --isa=rv32imf_zicntr_zihpm_zve32f_zvl128b_zvfh +signature=${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt --signature=${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt +signature-granularity=4 --signature-granularity=4 ${BUILD_DIR}/${TEST_NAME}_Spike.elf  
                RESULT_VARIABLE RETURN_SIM)
execute_process(COMMAND diff ${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt ${BUILD_DIR}/${TEST_NAME}_result.txt
                RESULT_VARIABLE RETURN_DIFF)
execute_process(COMMAND diff ${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt ${BUILD_DIR}/${TEST_NAME}_reference.txt
                RESULT_VARIABLE RETURN_REF)
                
if(RETURN_SIM)
        message(FATAL_ERROR "SPIKE SIMULATION ERROR")
else()
        if(RETURN_REF)
                message(FATAL_ERROR "SPIKE OUTPUT MISMATCH WITH EXPECTED DATA REFERENCE")
        endif()
        if(RETURN_DIFF)
                message(FATAL_ERROR "SPIKE OUTPUT MISMATCH WITH VERILATOR MODEL")
        endif()
endif()
