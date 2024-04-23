This is the build folder for programs compiled with LLVM 17 to be run using the Verilated Models

Create a /build directory here and run "cmake .." and "make" to build all unit tests for Vicuna.  

Running "make test" will run all unit tests with CTest.  A verilated model must be built in the ./build_verilated directory before running any tests
