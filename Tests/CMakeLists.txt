####
# Include file with macros for adding tests
####
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/add_test.cmake)


#### Add all unit tests for F Extension ####
#### Each test is a single, separate assembly file ####
if(USE_F)
    file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/FPU/*.S")
    foreach(file ${files})
      #Get name of the test
      string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
      add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
    endforeach()
    
     if(SPIKE)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/FPU/*.S")
        foreach(file ${files})
        #Get name of the test
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
        add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach() 
     endif()
    
endif()

#### Add all unit tests for F And Zve32x Extensions together ####
if(USE_F)
    if(USE_ZVE32X)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/FPU+VEC/*.S")
        foreach(file ${files})
          #Get name of the test
          string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
          add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach()
    
    
    
        if(SPIKE)
            file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/FPU+VEC/*.S")
            foreach(file ${files})
            #Get name of the test
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
            add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
            endforeach()
         endif()
     
     endif()
     
endif()

#### Add unit tests adapted from RISCV_TESTS for F ####
if(USE_F)
    file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/RISCV_TESTS_F/*.S")
    foreach(file ${files})
      #Get name of the test
      string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
      add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
    endforeach()
    
     if(SPIKE)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/RISCV_TESTS_F/*.S")
        foreach(file ${files})
        #Get name of the test
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
        add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach() 
     endif()
     
     #### Add unit tests adapted from RISCV_TESTS for ZFH ####
    if(USE_ZFH)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/RISCV_TESTS_ZFH/*.S")
        foreach(file ${files})
            #Get name of the test
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
            add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach()
    
        if(SPIKE)
            file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/RISCV_TESTS_ZFH/*.S")
            foreach(file ${files})
                #Get name of the test
                string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
                add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
            endforeach() 
        endif()
    
    endif()
    
endif()

#### Add Zve32f unit tests ####

if(USE_ZVE32F)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/ZVE32F/*.S")
        foreach(file ${files})
          #Get name of the test
          string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
          add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach()
    
    
    
        if(SPIKE)
            file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/ZVE32F/*.S")
            foreach(file ${files})
                #Get name of the test
                string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
                add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
            endforeach()
         endif()
     
endif()

#### Add Zvfh unit tests ####

if(USE_ZVFH)
        file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/ZVFH/*.S")
        foreach(file ${files})
          #Get name of the test
          string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
          add_unit_test(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
        endforeach()
    
    
    
        if(SPIKE)
            file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/ZVFH/*.S")
            foreach(file ${files})
                #Get name of the test
                string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
                add_unit_test_spike(${TEST_PATH} "${CUSTOM_TESTS_TOP}" "${BUILD_DIR}/Tests/")
            endforeach()
         endif()
     
endif()


