cmake_minimum_required(VERSION 3.10)
message(STATUS "CMake Version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")

set(BUILD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/build)
set(VERILATED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build)

#####
# Default Paths to dependencies.  If present, don't need to set these  TODO
#####


##########################
#Necessary Variables:
#
# RV_ARCH : select the processor architecture configuration for compilation
# FEATURES:
# 
#
#
##########################


#####
# Select RISCV_ARCH and RISCV_ABI based on selected features
#####

#Set this on the command line to change configuration.  Currently Supported: rv32im, rv32imv, rv32imf
set(RISCV_ARCH rv32im CACHE STRING "Specify the configuration")

#These control which unit tests are compiled
option(USE_F "Use the RISC-V F Extension" OFF)
option(USE_ZVE32X "Use the RISC-V Embedded V Extension" OFF)

if(${RISCV_ARCH} STREQUAL "rv32im") 
    set(RISCV_ABI ilp32)   
    
elseif(${RISCV_ARCH} STREQUAL "rv32imf")
    set(RISCV_ABI ilp32f)  
    set(USE_F ON)
    
elseif(${RISCV_ARCH} STREQUAL "rv32imzve32x")
    set(RISCV_ABI ilp32) 
    set(USE_ZVE32X ON)

else()
    message(FATAL_ERROR "Unsupported RISCV_ARCH selected")
    
endif()




set(RISCV_CMODEL "medany" CACHE STRING "mcmodel argument to the compiler")


#####
#Set LLVM 17 as the Compiler
#####

# Tell CMake about our processor
set(CMAKE_SYSTEM_PROCESSOR ${RISCV_ARCH})
# The Generic system name is used for bare-metal targets (without OS) in CMake
set(CMAKE_SYSTEM_NAME Generic)

#TODO: Parametrize selection of toolchain file
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../CMake/llvm_17_toolchain.cmake")

#set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../CMake/GCC_toolchain.cmake")




####
# Set build mode, Release by default
####
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RELEASE)
endif()


####
# Set some compiler options for easier debug or faster builds
####

# See whats going in CMake while getting the build process up and running
set(CMAKE_VERBOSE_MAKEFILE ON)

# Using C and C++ 11
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 11)

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g -ggdb")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g -ggdb")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wshadow -Wno-format -std=c11") 
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11")


#####################
# Setup the CMake Project
####################

set(CMAKE_EXECUTABLE_SUFFIX_C .elf)
set(CMAKE_EXECUTABLE_SUFFIX_CXX .elf)
set(CMAKE_EXECUTABLE_SUFFIX_ASM .elf) 
set(CMAKE_EXECUTABLE_SUFFIX ".elf") #For some reason setting this works for ASM files but SUFFIX_ASM doesnt


project(Zvhf_Software_Env LANGUAGES C CXX ASM DESCRIPTION "Compilation and Test Environment for Verification Tests and Benchmarks")
include(CTest)

########
#Add Program Subdirectories
########

#Vicuna Top level Directory.  Contains BSP and Vicuna unit tests for Zve32x
add_subdirectory(../Vicuna Vicuna)


#Custom Tests Directory.  Contains unit tests for F
add_subdirectory(../Tests Tests)







