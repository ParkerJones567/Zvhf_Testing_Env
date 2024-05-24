#!/bin/bash


INSTALL_PATH=$PWD/verilator

cd ../Toolchain

#Download
git clone https://github.com/verilator/verilator
unset VERILATOR_ROOT
cd verilator
git checkout tags/v4.210
autoconf
./configure --prefix $INSTALL_PATH
make
