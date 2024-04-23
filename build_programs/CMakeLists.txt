cmake_minimum_required(VERSION 3.10)
message(STATUS "CMake Version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")


#####
# Default Paths to dependencies.  If present, don't need to set these  TODO
#####


##########################
#Necessary Variables:
#
# RISCV_GCC_PREFIX: Path to GCC RISCV headers for desired architecture
# RISCV_LLVM_PREFIX:  PATH TO LLVM 17 bin folder
# FEATURES:
# 
#
#
##########################


#####
# Select RISCV_ARCH and RISCV_ABI based on selected features
#####
set(RISCV_ARCH rv32imv) #Parametrize this in the future
set(RISCV_ABI ilp32)    #Depends on RISCV_ARCH selected
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
set(CMAKE_EXECUTABLE_SUFFIX ".elf") #For some reason setting this


project(Zvhf_Software_Env LANGUAGES C CXX ASM DESCRIPTION "Compilation and Test Environment for Verification Tests and Benchmarks")
include(CTest)

########
#Select Applications
########

#Vicuna Top level Directory
add_subdirectory(../Vicuna Vicuna)








