#!/bin/bash

#Top level script to setup dependencies/toolchain.  Each has a helper script to setup which is called here
#
#Necessary dependencies:
#   -verilator:  verilator version 4.210 is built from source.
#   -llvm 18  :  prebuilt llvm 18 is downloaded from sync and share using the same script used for the muRISCV-nn project (https://github.com/tum-ei-eda/muriscv-nn.git).  This is the main compiler
#   -GCC      :  RISCV GCC headers are needed for each supported architecture.  TODO: add these to the sync-and-share system used for muRISCV-nn.  currently built from source
#   -spike    :  the riscv-isa-sim is used to validate vicuna results.  built from source





######
#   Verilator setup
######

./build_verilator.sh


######
#   llvm setup
######

./download_helper.sh ../Toolchain/llvm/ LLVM default 18.1.4 llvm  WORKS



######
#   GCC setup
######

#Will use download helper eventually.  For now, building from source.  Takes a very long time
./build_gcc.sh rv32im ilp32
./build_gcc.sh rv32imf ilp32f
./build_gcc.sh rv32imfzfh ilp32f
./build_gcc.sh rv32imzve32x ilp32
./build_gcc.sh rv32imfzve32x ilp32f
./build_gcc.sh rv32imfzve32f ilp32f
./build_gcc.sh rv32imfzfhzve32fzvfh ilp32f


######
#   spike setup
######

./build_spike.sh


######
#   tflm setup
######

./download_tflm.sh