This is the top level testing environment for the Vicuna Processor extended with Zvhf support


# Submodules
To download all submodules, run 

```
git submodule update --init --recursive
```

Necessary submodules are:
    - vicuna-zve32f-zvhf                : fork of TUWien Vicuna project with added support for F, Zhf(in progress), Zve32f(in progress), and Zvhf(in progress) extensions.
    - vicuna-zve32f-zvhf/cv32e40x       : fork of OpenHWGroup cv32e40x project with bug fixes.  Based on original commit needed as the main core for Vicuna
    - Vicuna-zve32f-zvhf/fpu_ss         : fork of Pulp fpu_ss project for F extension support.  Contains bug fixes and Zhf support(in progress)
    - Vicuna-zve32f-zvhf/fpu_ss/fpnew   : OpenHWGroup fpnew (cvfpu) project.  Floating point unit used for all floating point operations
    - vicuna-zve32f-zvhf/ibex           : lowRISC Ibex core.  This is the other main core used for the original Vicuna project.  Not currently supported for floating point operation, so is not needed for this project
    
# Dependencies

To setup all dependencies, run 
```
'Scripts/setup_toolchain.sh'
```
This will call other helper scripts to:
    - Download a prebuilt version of LLVM 18
    - Build all required GCC versions
    - Build Verilator v4.210
    - Build Spike
    
    
    
    
# Build Verilated Model

build_verilated - build directory to build the verilated model of the vicuna project with the desired RISC-V architecture.

To build:
```
mkdir build_verilated/build
cd build_verilated/build
cmake .. -DRISCV_ARCH=ARCHITECTURE
make
```

Valid values for ARCHITECTURE are:
    rv32im
    rv32imf
    rv32imzve32x
    rv32imfzve32x
    
Adding the flag '-DTRACE=ON' to the 'cmake' command allows the build verilated model to create VCD traces



# Build Programs

build_programs - build directory to build the unit tests and programs(in progress) for the desired RISC-V architecture.  Tests can be run with CTEST and verified automatically.  The verilated model must be built first.

To build:
```
mkdir build_programs/build
cd build_programs/build
cmake .. -DRISCV_ARCH=ARCHITECTURE
make
make test
```

adding the flag '-DSPIKE=ON' to the 'cmake' command re-runs all unit tests with the spike simulator and validates the outputs with those produced by the verilated model.
(Some current issues with this, possibly bugs with spike)



