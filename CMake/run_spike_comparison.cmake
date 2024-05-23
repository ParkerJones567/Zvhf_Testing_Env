#Script to run the tests and compare the outputs  Add_test only allows a single command, so this script does the comparison with expected outputs
#All variables must be passed in from the Add_Tests COMMAND argument
#For reuse, provide the direct path to the files for SPIKE_DIR and BUILD_DIR
execute_process(COMMAND ${SPIKE_DIR}/spike --isa=rv32imfv_zicntr_zihpm --varch=vlen:1024,elen:64 +signature=${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt --signature=${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt +signature-granularity=4 --signature-granularity=4 ${BUILD_DIR}/${TEST_NAME}_Spike.elf  
                RESULT_VARIABLE RETURN_SIM)
execute_process(COMMAND diff ${BUILD_DIR}/${TEST_NAME}_result.txt ${BUILD_DIR}/${TEST_NAME}_Spike_reference.txt 
                RESULT_VARIABLE RETURN_DIFF)
                
if(RETURN_SIM)
        message(FATAL_ERROR "SIMULATION ERROR")
else()
        if(RETURN_DIFF)
                message(FATAL_ERROR "OUTPUT ERROR")
        endif()
endif()
