####
# Include file with macros for adding tests
####
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/add_test.cmake)
####
#Add bsp library for Vicuna
####


#Need to add the Linker script again here for some reason.
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/sw/lld_link.ld")




####Add all unit tests for F Extension####
#### CURRENTLY NOT CONFIRMING CORRECT OUTPUT FOR UNIT TESTS DUE TO ISSUE GENERATING THE DUMP FILES ####
####Each test is a single, separate assembly file####
if(USE_F)
    file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/FPU/*.S")
    foreach(file ${files})
      #Get name of the test
      string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" TEST_PATH ${file})
      add_unit_test(${TEST_PATH})
    endforeach()
endif()


