cmake_minimum_required(VERSION 3.10)
message(STATUS "CMake Version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")

#This file is used to build the verilated models of CV32E40X and Vicuna

#####################
# Setup the CMake Project
####################

project(Verilated-Builds LANGUAGES C CXX DESCRIPTION "Environment for Verilating Models")
find_package(verilator HINTS ${CMAKE_CURRENT_SOURCE_DIR}/../Toolchain/verilator) #TODO-Point to correct path of verilator (use source location, don't install?  does strange stuff with share directory)

# See whats going in CMake while getting the build process up and running
set(CMAKE_VERBOSE_MAKEFILE ON)

# Using C and C++ 11
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 11)

####
#Verilate the Vicuna and CV32E40X Model
####

#These Parameters will all be set on command line
set(VPROC_CONFIG dual)
set(VREG_W 128)  
set(VMEM_W 32)

set(MEM_W 32)
set(MEM_SZ 262144)      
set(MEM_LATENCY 1)  #MUST BE SET TO 1 IF CACHE DISABLED OR VICUNA LOCKS UP (probably due to mismatch with value given to verilated model)
set(ICACHE_SZ 0)
set(ICACHE_LINE_W 128)
set(DCACHE_SZ 0)       
set(DCACHE_LINE_W 512)
 
#Path to CV32E40X sources               
set(DESIGN_RTL_DIR_CV32E40X ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/cv32e40x/rtl)
#Path to VICUNA sources  
set(DESIGN_RTL_DIR_VICUNA ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/rtl)
#Path to VICUNA Sim dir
set(VICUNA_SIM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/sim/)


set(CV32E40X_SOURCE ${DESIGN_RTL_DIR_CV32E40X}/include/cv32e40x_pkg.sv  #Sources Needed for CV32E40X.  Not all need to be included, just top level files
                ${DESIGN_RTL_DIR_CV32E40X}/if_c_obi.sv
                ${DESIGN_RTL_DIR_CV32E40X}/if_xif.sv
                ${DESIGN_RTL_DIR_CV32E40X}/../bhv/cv32e40x_sim_clock_gate.sv)
               

set(CV32E40X_INCLUDE ${DESIGN_RTL_DIR_CV32E40X}     #CV32E40X Include Dirs
                ${DESIGN_RTL_DIR_CV32E40X}/include
                ${DESIGN_RTL_DIR_CV32E40X}/../bhv)
                     
                     
set(VICUNA_SOURCE  ${DESIGN_RTL_DIR_VICUNA}/vproc_pkg.sv #Vicuna sources.  Not all need to be included, just top level files
                /${DESIGN_RTL_DIR_VICUNA}/../vproc_config.sv 
                ${DESIGN_RTL_DIR_VICUNA}/vproc_top.sv
                ${DESIGN_RTL_DIR_VICUNA}/vproc_xif.sv
                ${DESIGN_RTL_DIR_VICUNA}/vproc_core.sv
                ${DESIGN_RTL_DIR_VICUNA}/vproc_vregpack.sv
                ${DESIGN_RTL_DIR_VICUNA}/vproc_vregunpack.sv)

set(VICUNA_INCLUDE ${DESIGN_RTL_DIR_VICUNA}         #Vicuna Include Dirs
                   ${DESIGN_RTL_DIR_VICUNA}/../sva)
                   

#Generate vproc_config.sv for chosen configuration
#TODO:find better way to set required env variables for make call to generate vproc_config.sv
set(ENV{VPROC_CONFIG} ${VPROC_CONFIG})
set(ENV{VREG_W} ${VREG_W})
set(ENV{VMEM_W} ${VMEM_W})
execute_process(COMMAND rm -f vproc_config.sv
                COMMAND make -f config.mk VPROC_CONFIG_PKG=vproc_config.sv
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf)


#Create the verilated model 
add_executable(verilated_model ${VICUNA_SIM_DIR}verilator_main.cpp)

verilate(verilated_model SOURCES ${VICUNA_SOURCE} ${CV32E40X_SOURCE}
               INCLUDE_DIRS  ${VICUNA_INCLUDE} ${CV32E40X_INCLUDE}
               TOP_MODULE vproc_top 
               PREFIX Vvproc_top
               VERILATOR_ARGS -cc -exe ${VICUNA_SIM_DIR}verilator_main.cpp --unroll-count 1024 
                              -Wno-WIDTH -Wno-PINMISSING -Wno-UNOPTFLAT   
	                          -Wno-UNSIGNED -Wno-IMPLICIT -Wno-LITENDIAN -Wno-CASEINCOMPLETE        
	                          -Wno-SYMRSVDWORD -Wno-BLKANDNBLK -Wno-BLKSEQ -Wno-SYNCASYNCNET        
	                          -Wno-COMBDLY 
                              #+define+COREV_ASSERT_OFF #Fixes UVM error with CV32E40X (Needed when not using -DVPROC_SVA)
	                          --clk clk_i
	                          --assert -DVPROC_SVA
                              -GMEM_W=${MEM_W} -GVMEM_W=${VMEM_W} -GICACHE_SZ=${ICACHE_SZ} -GICACHE_LINE_W=${ICACHE_LINE_W} -GDCACHE_SZ=${DCACHE_SZ} -GDCACHE_LINE_W=${DCACHE_LINE_W}
                              -DMAIN_CORE_CV32E40X
                              -CFLAGS "-std=gnu++11 -O2 -DSIM_ABORT_CYCLES=10000")

