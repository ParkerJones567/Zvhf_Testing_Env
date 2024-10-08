cmake_minimum_required(VERSION 3.10)
message(STATUS "CMake Version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")

##########################
#
# Configuration variables:
# - RV_ARCH : select the processor architecture configuration for compilation
#
# FEATURES:
# - SPIKE : enable reference checking with Spike. (Some tests cause issues, believed to be bugs with Spike)
# - TRACE : enables .csv memory trace and .vcd signal trace output for unit tests.  Due to large file sizes, only trace of last test run will be kept.  Will be located in /build/Testing
#
#
##########################

#Set this on the command line to change configuration.  Currently Supported: rv32im, rv32imzve32x, rv32imf, rv32imfzve32x, rv32imfzve32f
set(RISCV_ARCH rv32im CACHE STRING "Specify the configuration")
set(MEM_LATENCY 1 CACHE STRING "Memory latency")
set(MIN_VLEN 128 CACHE STRING "LLVM Autovectorizer parameter for minimum VLEN")

option(SPIKE        "Run with Spike Baremetal"  OFF)
option(SPIKE_PK     "Run with Spike and PK"     OFF)
option(TRACE        "Enable trace outputs"      OFF)
option(BENCHMARKS   "Run Benchmarks"            ON)
option(PRINT "Enable print statements"      OFF) #Turn off when caches enabled

set(TOOLCHAIN LLVM CACHE STRING "GCC OR LLVM")


#####
# Default Paths to Subdirectories
#####

set(BUILD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/build)
set(VERILATED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../build_verilated/build)
set(VICUNA_SOURCE_TOP ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf)
set(CUSTOM_TESTS_TOP ${CMAKE_CURRENT_SOURCE_DIR}/../Tests)
set(CMAKE_TOP ${CMAKE_CURRENT_SOURCE_DIR}/../CMake)
set(BENCHMARKS_TOP ${CMAKE_CURRENT_SOURCE_DIR}/../Benchmarks)
set(SPIKE_SOURCES_TOP ${CMAKE_CURRENT_SOURCE_DIR}/../Spike)


#####
# Select RISCV_ARCH and RISCV_ABI and Autovectorization flags based on selected features
#####

#These control which unit tests are compiled based on selected RISCV_ARCH
option(USE_F "Use the RISC-V F Extension" OFF)
option(USE_ZFH "Use the RISC-V ZFH Extension" OFF)
option(USE_ZVE32X "Use the RISC-V Embedded V Extension" OFF)
option(USE_ZVE32F "Use the RISC-V Embedded V Float Extension" OFF)
option(USE_ZVHF "Use the RISC-V V Half Float Extension" OFF)


set(AUTOVEC_FLAGS "")




if(${RISCV_ARCH} STREQUAL "rv32im") 
    set(RISCV_ABI ilp32)  
    
elseif(${RISCV_ARCH} STREQUAL "rv32imf")
    set(RISCV_ABI ilp32f)  
    set(USE_F ON)
    
elseif(${RISCV_ARCH} STREQUAL "rv32imfzfh")
    set(RISCV_ABI ilp32f)  
    set(USE_F ON)
    set(USE_ZFH ON)
    
elseif(${RISCV_ARCH} STREQUAL "rv32imzve32x")
    set(RISCV_ABI ilp32) 
    set(USE_ZVE32X ON)
    set(AUTOVEC_FLAGS "-fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=${MIN_VLEN}")
    
elseif(${RISCV_ARCH} STREQUAL "rv32imfzve32x")
    set(RISCV_ABI ilp32f) 
    set(USE_ZVE32X ON)
    set(USE_F ON)
    set(AUTOVEC_FLAGS "-fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=${MIN_VLEN}")
    
elseif(${RISCV_ARCH} STREQUAL "rv32imfzve32f")
    set(RISCV_ABI ilp32f) 
    set(USE_ZVE32X ON)
    set(USE_ZVE32F ON)
    set(USE_F ON)
    set(AUTOVEC_FLAGS "-fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=${MIN_VLEN}")
    
elseif(${RISCV_ARCH} STREQUAL "rv32imf_zfh_zvfh")
    set(RISCV_ABI ilp32f) 
    set(USE_ZVE32X ON)
    set(USE_ZVE32F ON)
    set(USE_ZFH ON)
    set(USE_F ON)
    set(USE_ZVFH ON)
    set(AUTOVEC_FLAGS "-fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=${MIN_VLEN}")
    

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

#Select toolchain file
if(${TOOLCHAIN} STREQUAL "LLVM")
    message("USING LLVM")
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../CMake/llvm_18_toolchain.cmake")
else()
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../CMake/GCC_toolchain.cmake")
endif()

####
# Set build mode, Release by default
####
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RELEASE)
endif()

if(PRINT)
  add_definitions(-DPRINT_OUTPUTS)
endif()


####
# Set some compiler options for easier debug or faster builds
####

# See whats going in CMake while getting the build process up and running
set(CMAKE_VERBOSE_MAKEFILE ON)

# Using C and C++ 11
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 11)

#set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O3 -g -ggdb -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256")
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O3 -g -ggdb -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256")
#set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256")
#set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wshadow -Wno-format -std=c11 -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256") 
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -fvectorize -fslp-vectorize -mllvm -scalable-vectorization=preferred -mllvm --riscv-v-vector-bits-min=256")

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O3 -g -ggdb ${AUTOVEC_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O3 -g -ggdb ${AUTOVEC_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 ${AUTOVEC_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 ${AUTOVEC_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wshadow -Wno-format -std=c11 ${AUTOVEC_FLAGS}") 
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 ${AUTOVEC_FLAGS}")


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

if(NOT BENCHMARKS) 
    #Custom Tests Directory.  Contains unit tests for F and F+V and Zve32f
    add_subdirectory(../Tests Tests)
endif()

#Spike Directory.  Contains Library to use when running with Spike for reference outputs
add_subdirectory(../Spike Spike)


#SW Directory.  Contains benchmarks
if(BENCHMARKS) 
    add_subdirectory(../Benchmarks Benchmarks)
endif()








