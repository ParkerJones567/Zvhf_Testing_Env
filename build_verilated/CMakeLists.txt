cmake_minimum_required(VERSION 3.10)
message(STATUS "CMake Version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")

###This file is used to build the verilated models of CV32E40X and Vicuna###

########################
# Arguments
#
# RV_ARCH : select the processor architecture configuration to verilate
# TRACE   : If defined, enable vcd trace outputs.  WARNING: Traces can be very large (GBs)
#


#####################
# Setup the CMake Project
####################

project(Verilated-Builds LANGUAGES C CXX DESCRIPTION "Environment for Verilating Models")
find_package(verilator HINTS ${CMAKE_CURRENT_SOURCE_DIR}/../Toolchain/verilator)

# See whats going in CMake while getting the build process up and running
set(CMAKE_VERBOSE_MAKEFILE ON)

# Using C and C++ 11
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 11)

option(TRACE "Enable VCD trace outputs" OFF)

##############
# Configuration Selection
##############

#Set this on the command line to change configuration.  Currently Supported: rv32im, rv32imzve32x, rv32imf, rv32imfzhf, rv32imfzve32x
set(RISCV_ARCH rv32im CACHE STRING "Specify the configuration")


#set the variables to include the correct modules/connections in the project
if(${RISCV_ARCH} STREQUAL "rv32im") #Build only CV32E40X
    set(ARCH_XIF_FLAG  ) 
    set(ARCH_FPU_FLAG  )
    set(ARCH_ZFH_FLAG  )
    set(ARCH_VIC_FLAG  )  
    
elseif(${RISCV_ARCH} STREQUAL "rv32imf") #Build CV32E40X with FPU on the Xif interface
    set(ARCH_XIF_FLAG -DXIF_ON ) 
    set(ARCH_FPU_FLAG -DSCALAR_FPU_ON )
    set(ARCH_ZFH_FLAG  )
    set(ARCH_VIC_FLAG  ) 
    
elseif(${RISCV_ARCH} STREQUAL "rv32imfzfh") #Build CV32E40X with FPU on the Xif interface with half-float support
    set(ARCH_XIF_FLAG -DXIF_ON ) 
    set(ARCH_FPU_FLAG -DSCALAR_FPU_ON )
    set(ARCH_ZFH_FLAG -DZFH_ON )
    set(ARCH_VIC_FLAG  )   
    
elseif(${RISCV_ARCH} STREQUAL "rv32imzve32x") #Build CV32E40X with Vicuna on the Xif interface
    set(ARCH_XIF_FLAG -DXIF_ON ) 
    set(ARCH_FPU_FLAG  )
    set(ARCH_ZFH_FLAG  )
    set(ARCH_VIC_FLAG -DVICUNA_ON ) 
     
elseif(${RISCV_ARCH} STREQUAL "rv32imfzve32x") #Build CV32E40X with Vicuna and FPU on the Xif interface
    set(ARCH_XIF_FLAG -DXIF_ON ) 
    set(ARCH_FPU_FLAG -DSCALAR_FPU_ON )
    set(ARCH_ZFH_FLAG  )
    set(ARCH_VIC_FLAG -DVICUNA_ON )

else()
    message(FATAL_ERROR "Unsupported RISCV_ARCH selected")
    
endif()

####
# Vicuna configuration Variables
####

#These Parameters need to be set on the command line.  
set(VPROC_CONFIG dual)
set(VREG_W 128)  
set(VMEM_W 32)

set(MEM_W 32)
set(MEM_SZ 262144)      
set(MEM_LATENCY 1)  #Needs to match value given to verilated model on the command line.  TODO: combine both verilated model and program CMAKE as subprojects and control this that way
set(ICACHE_SZ 0)
set(ICACHE_LINE_W 128)
set(DCACHE_SZ 0)       
set(DCACHE_LINE_W 512)



####
# Sources/Include Directories
####
 
#Path to CV32E40X sources               
set(DESIGN_RTL_DIR_CV32E40X ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/cv32e40x/rtl)

#Path to VICUNA sources  
set(DESIGN_RTL_DIR_VICUNA ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/rtl)
#Path to VICUNA Sim dir
set(VICUNA_SIM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/sim/)

#Path to FPU_SS sources
set(DESIGN_RTL_DIR_FPU_SS ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/fpu_ss/src)
#Path to FPNEW sources
set(DESIGN_RTL_DIR_FPNEW ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf/fpu_ss/fpnew/src)


set(CV32E40X_SOURCE ${DESIGN_RTL_DIR_CV32E40X}/include/cv32e40x_pkg.sv                  #Sources Needed for CV32E40X
                    ${DESIGN_RTL_DIR_CV32E40X}/if_c_obi.sv
                    ${DESIGN_RTL_DIR_CV32E40X}/if_xif.sv
                    ${DESIGN_RTL_DIR_CV32E40X}/../bhv/cv32e40x_sim_clock_gate.sv)
               

set(CV32E40X_INCLUDE ${DESIGN_RTL_DIR_CV32E40X}                                         #CV32E40X Include Dirs
                    ${DESIGN_RTL_DIR_CV32E40X}/include
                    ${DESIGN_RTL_DIR_CV32E40X}/../bhv)
                     
                     
set(VICUNA_SOURCE   ${DESIGN_RTL_DIR_VICUNA}/vproc_pkg.sv                               #Vicuna sources
                    ${DESIGN_RTL_DIR_VICUNA}/../vproc_config.sv 
                    ${DESIGN_RTL_DIR_VICUNA}/vproc_top.sv
                    ${DESIGN_RTL_DIR_VICUNA}/vproc_xif.sv
                    ${DESIGN_RTL_DIR_VICUNA}/vproc_core.sv
                    ${DESIGN_RTL_DIR_VICUNA}/vproc_vregpack.sv
                    ${DESIGN_RTL_DIR_VICUNA}/vproc_vregunpack.sv)

set(VICUNA_INCLUDE  ${DESIGN_RTL_DIR_VICUNA}                                            #Vicuna Include Dirs
                    ${DESIGN_RTL_DIR_VICUNA}/../sva)
                   
set(FPNEW_SOURCE    ${DESIGN_RTL_DIR_FPNEW}/fpnew_pkg.sv 
                    ${DESIGN_RTL_DIR_FPNEW}/common_cells/src/cf_math_pkg.sv             #FPNEW Sources
                    ${DESIGN_RTL_DIR_FPNEW}/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
                    ${DESIGN_RTL_DIR_FPNEW}/fpnew_top.sv)


set(FPNEW_INCLUDE   ${DESIGN_RTL_DIR_FPNEW}                                             #FPNEW Include Dirs
                    ${DESIGN_RTL_DIR_FPNEW}/common_cells/include
                    ${DESIGN_RTL_DIR_FPNEW}/common_cells/src
                    ${DESIGN_RTL_DIR_FPNEW}/fpu_div_sqrt_mvp/hdl)               
                   
                   
set(FPU_SS_SOURCE   ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss_pkg.sv                              #FPU_SS Sources
                    ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss_prd_f_pkg.sv
                    ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss_prd_f_zfh_pkg.sv
                    ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss_prd_zfinx_pkg.sv
                    ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss_instr_pkg.sv
                    ${DESIGN_RTL_DIR_FPU_SS}/fpu_ss.sv )


set(FPU_SS_INCLUDE  ${DESIGN_RTL_DIR_FPU_SS} )                                          #FPU_SS Include Dirs
                 
                   
####
#Generate vproc_config.sv for chosen configuration.  Must be generated before verilating
####
#TODO:Is there a better way to set required env variables for 'make' call to generate vproc_config.sv?
set(ENV{VPROC_CONFIG} ${VPROC_CONFIG})
set(ENV{VREG_W} ${VREG_W})
set(ENV{VMEM_W} ${VMEM_W})
execute_process(COMMAND rm -f vproc_config.sv
                COMMAND make -f config.mk VPROC_CONFIG_PKG=vproc_config.sv
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../Vicuna/vicuna_zve32f_zvhf)



if(TRACE)
    add_definitions(-DTRACE_VCD)
    set(TRACE TRACE)
endif()


#Todo: allow user to set this
add_definitions(-DABORT_CYCLES=10000)

#Create the verilated model 
add_executable(verilated_model ${VICUNA_SIM_DIR}verilator_main.cpp)


verilate(verilated_model SOURCES ${FPNEW_SOURCE} ${FPU_SS_SOURCE} ${VICUNA_SOURCE} ${CV32E40X_SOURCE}
               INCLUDE_DIRS  ${FPNEW_INCLUDE} ${FPU_SS_INCLUDE} ${VICUNA_INCLUDE} ${CV32E40X_INCLUDE}
               TOP_MODULE vproc_top 
               PREFIX Vvproc_top
               ${TRACE}                                    
               VERILATOR_ARGS -cc -exe ${VICUNA_SIM_DIR}verilator_main.cpp --unroll-count 1024 
                              -Wno-WIDTH -Wno-PINMISSING -Wno-UNOPTFLAT   
	                          -Wno-UNSIGNED -Wno-IMPLICIT -Wno-LITENDIAN -Wno-CASEINCOMPLETE        
	                          -Wno-SYMRSVDWORD -Wno-BLKANDNBLK -Wno-BLKSEQ -Wno-SYNCASYNCNET        
	                          -Wno-COMBDLY 
	                          -Wno-WIDTHCONCAT         
                              #+define+COREV_ASSERT_OFF       #Fixes UVM error with CV32E40X (Needed when not using -DVPROC_SVA)
	                          --clk clk_i
	                          --assert -DVPROC_SVA
                              -GMEM_W=${MEM_W} -GVMEM_W=${VMEM_W} -GICACHE_SZ=${ICACHE_SZ} -GICACHE_LINE_W=${ICACHE_LINE_W} -GDCACHE_SZ=${DCACHE_SZ} -GDCACHE_LINE_W=${DCACHE_LINE_W}
                              -DMAIN_CORE_CV32E40X #Flag to select CV32E40X as scalar core
                              ${ARCH_XIF_FLAG} #Each flag must be in a separate variable or they don't get passed correctly
                              ${ARCH_FPU_FLAG} 
                              ${ARCH_ZFH_FLAG} 
                              ${ARCH_VIC_FLAG}                    
                              -CFLAGS "-std=gnu++11 -O2 -DSIM_ABORT_CYCLES=10000")  #Not sure if Sim_abort_cycles is necessary, possibly misnamed from ABORT CYCLES.  This is from the old vicuna makefile

