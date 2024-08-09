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



add_library(UART_Vicuna STATIC)

target_include_directories(UART_Vicuna PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib
)

target_sources(UART_Vicuna PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/runtime.h
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/runtime.c
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/uart.h
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/uart.c
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/vicuna_crt.h
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/vicuna_crt.c
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/terminate_benchmark.h
  ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/sw/lib/terminate_benchmark.c
)


####
#Add Validation Tests
####
if(USE_ZVE32X)
    add_code_test_vicuna(test ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/docs/code ${BUILD_DIR}/Vicuna)    
    #add_code_test_vicuna(opt_test ${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/docs/code ${BUILD_DIR}/Vicuna)
endif()



#### Add all unit tests in vicuna/test directory if Zve32x is enabled ####
#### Each test is a single, separate assembly file ####

if(NOT BENCHMARKS)

    if(USE_ZVE32X)

        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/*/*.S")
        foreach(file ${files})
            #Get name of the test
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/" "" TEST_PATH ${file})
            add_unit_test(${TEST_PATH} "${VICUNA_SOURCE_TOP}/test/" "${BUILD_DIR}/Vicuna/")
        endforeach()
        
        if(SPIKE)
            
            file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/*/*.S")
            foreach(file ${files})
                #Get name of the test
                string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/vicuna_zve32f_zvhf/test/" "" TEST_PATH ${file})
                add_unit_test_spike(${TEST_PATH} "${VICUNA_SOURCE_TOP}/test/" "${BUILD_DIR}/Vicuna/")
            endforeach()
        
        
        endif()
        
        
    endif()

endif()


