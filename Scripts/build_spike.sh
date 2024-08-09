#!/bin/bash

cd ../Spike

#Build Spike
echo "Building Spike"
git clone https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
export RISCV=$PWD/../../Toolchain/GCC/rv32imf_zfh_zvfh
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



#Build PK for ilp32
echo "Building pk_ilp32"
cd riscv-pk
rm -r build
export RISCV=/home/parker/Desktop/thesis/working/15_05_working/Zvhf_Testing_Env/Toolchain/GCC/rv32im
export PATH=$PATH_ORIG:$RISCV/bin
echo $PATH
mkdir build
cd build
../configure --prefix=$RISCV --host=riscv32-unknown-elf --with-arch=rv32im_zicntr_zihpm_zifencei --with-abi=ilp32
make
sudo make install

#copy ilp32 to bin folder
cd ../..
cp $PWD/riscv-pk/build/pk pk_ilp32



#Build PK for ilp32f
echo "Building pk_ilp32f"
cd riscv-pk
rm -r build
export RISCV=/home/parker/Desktop/thesis/working/15_05_working/Zvhf_Testing_Env/Toolchain/GCC/rv32imf
export PATH=$PATH_ORIG:$RISCV/bin
echo $PATH
mkdir build
cd build
../configure --prefix=$RISCV --host=riscv32-unknown-elf --with-arch=rv32imf_zicntr_zihpm_zifencei --with-abi=ilp32
make
sudo make install

#copy ilp32 to bin folder
cd ../..
cp $PWD/riscv-pk/build/pk pk_ilp32f
