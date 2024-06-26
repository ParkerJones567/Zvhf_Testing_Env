#!/bin/bash

cd ../Spike

#Build Spike
echo "Building Spike"
git clone https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
export RISCV=$PWD/../../Toolchain/GCC/rv32imfzfhzve32x
export PATH=$PATH:$RISCV/bin
echo $PATH
mkdir build
cd build
../configure --prefix=$RISCV
make

#Copy spike to top level Spike folder
echo "Copying Spike"

cd ../..
cp $PWD/riscv-isa-sim/build/spike spike
