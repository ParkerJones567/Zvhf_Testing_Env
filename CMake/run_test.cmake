#Script to run the tests and compare the outputs  Add_test only allows a single command, so this script does the comparison with expected outputs
#All variables must be passed in from the Add_Tests COMMAND argument
#For reuse, provide the direct path to the files for VERILATED_DIR and BUILD_DIR
#Provide the paths for the mem_trace .csv and signal trace .vcd as XXX_TRACE_ARGS to get those outputs.  
execute_process(COMMAND .${VERILATED_DIR}/verilated_model ${BUILD_DIR}/prog_${TEST_NAME}.txt 32 4194304 ${MEM_LATENCY} 1 ${MEM_TRACE_ARGS} ${VCD_TRACE_ARGS}
                RESULT_VARIABLE RETURN_SIM)
execute_process(COMMAND diff ${BUILD_DIR}/${TEST_NAME}_result.txt ${BUILD_DIR}/${TEST_NAME}_reference.txt 
                RESULT_VARIABLE RETURN_DIFF)
                
if(RETURN_SIM)
        message(FATAL_ERROR "SIMULATION ERROR")
else()
        if(RETURN_DIFF)
                message(FATAL_ERROR "OUTPUT ERROR")
        endif()
endif()
