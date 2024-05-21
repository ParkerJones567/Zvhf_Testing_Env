
set(RISCV_GCC_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../Toolchain/GCC/${RISCV_ARCH}" CACHE PATH "Install location of GCC RISC-V toolchain.")
set(RISCV_GCC_BASENAME "riscv32-unknown-elf" CACHE STRING "Base name of the toolchain executables.")

set(RISCV_LLVM_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../Toolchain/llvm/bin" CACHE PATH "Install location of LLVM RISC-V toolchain.")

set(CMAKE_C_COMPILER ${RISCV_LLVM_PREFIX}/clang-18)
set(CMAKE_CXX_COMPILER ${RISCV_LLVM_PREFIX}/clang-18)
set(CMAKE_ASM_COMPILER ${RISCV_LLVM_PREFIX}/clang-18)
set(CMAKE_OBJCOPY ${RISCV_LLVM_PREFIX}/llvm-objcopy-18)
set(CMAKE_OBJDUMP ${RISCV_LLVM_PREFIX}/llvm-objdump-18)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --target=riscv32 -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -mcmodel=${RISCV_CMODEL}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --gcc-toolchain=${RISCV_GCC_PREFIX} --sysroot=${RISCV_GCC_PREFIX}/${RISCV_GCC_BASENAME}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --target=riscv32 -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -mcmodel=${RISCV_CMODEL}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --gcc-toolchain=${RISCV_GCC_PREFIX} --sysroot=${RISCV_GCC_PREFIX}/${RISCV_GCC_BASENAME}")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} --target=riscv32 -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -mcmodel=${RISCV_CMODEL}")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} --gcc-toolchain=${RISCV_GCC_PREFIX} --sysroot=${RISCV_GCC_PREFIX}/${RISCV_GCC_BASENAME}")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -fuse-ld=lld -mcmodel=${RISCV_CMODEL} -nostartfiles")
