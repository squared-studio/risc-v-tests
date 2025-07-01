################################################################################
#
#  Integer Register Tests
#  Author: Foez Ahmed (foez.official@gmail.com)
#
#  This file is part of squared-studio:risc-v-tests
#  Copyright (c) 2025 squared-studio
#  Licensed under the MIT License
#  See LICENSE file in the project root for full license information
#
################################################################################

# This header file provides macros and definitions for bare-metal RISC-V
# assembly tests, primarily for use in simulation environments like Spike.
#include "ss_riscv_asm.S"

################################################################################
# Macro Define : Local macro defination
################################################################################

# Macros to write a register's value to memory, conditionally compiled for
# 32-bit (RV32) or 64-bit (RV64) architectures.
#if __riscv_xlen == 64
        # For RV64, use 'sd' (store doubleword) and increment pointer by 8.
        #define WR_HI(REG)                      \
                sd      REG,    0(x31);         \
                addi    x31,    x31,    8;
        #define WR_LO(REG)                      \
                sd      REG,    0(x15);         \
                addi    x15,    x15,    8;
#else
        # For RV32, use 'sw' (store word) and increment pointer by 4.
        #define WR_HI(REG)                      \
                sw      REG,    0(x31);         \
                addi    x31,    x31,    4;
        #define WR_LO(REG)                      \
                sw      REG,    0(x15);         \
                addi    x15,    x15,    4;
#endif


# Macro to test a lower-half GPR (x0-x15).
# It loads a pseudo-random immediate value into the register and then writes
# that value to the memory region pointed to by x31.
#define GPR_TEST_LO(REG)                        \
        li      REG,    RAND;                   \
        WR_HI(REG);

# Macro to test an upper-half GPR (x16-x31).
# It loads a pseudo-random immediate value into the register and then writes
# that value to the memory region pointed to by x15.
#define GPR_TEST_HI(REG)                        \
        li      REG,    RAND;                   \
        WR_LO(REG);

################################################################################
# Program Entry Point
################################################################################

_start:
        # Load the base address of the memory region for lower registers
        # (x0-x15) into x31. x31 will be used as a pointer to store the test
        # results.
        la      x31,    LOWER_REGS

        # Test each of the lower 16 General Purpose Registers (x0-x15).
        # Note: x0 is hardwired to zero, so `li x0, ...` is a no-op. The test
        # will correctly store 0.
        GPR_TEST_LO(x0);  GPR_TEST_LO(x0);  GPR_TEST_LO(x0);  GPR_TEST_LO(x0);
        GPR_TEST_LO(x0);  GPR_TEST_LO(x0);  GPR_TEST_LO(x0);  GPR_TEST_LO(x0);
        GPR_TEST_LO(x1);  GPR_TEST_LO(x1);  GPR_TEST_LO(x1);  GPR_TEST_LO(x1);
        GPR_TEST_LO(x1);  GPR_TEST_LO(x1);  GPR_TEST_LO(x1);  GPR_TEST_LO(x1);
        GPR_TEST_LO(x2);  GPR_TEST_LO(x2);  GPR_TEST_LO(x2);  GPR_TEST_LO(x2);
        GPR_TEST_LO(x2);  GPR_TEST_LO(x2);  GPR_TEST_LO(x2);  GPR_TEST_LO(x2);
        GPR_TEST_LO(x3);  GPR_TEST_LO(x3);  GPR_TEST_LO(x3);  GPR_TEST_LO(x3);
        GPR_TEST_LO(x3);  GPR_TEST_LO(x3);  GPR_TEST_LO(x3);  GPR_TEST_LO(x3);
        GPR_TEST_LO(x4);  GPR_TEST_LO(x4);  GPR_TEST_LO(x4);  GPR_TEST_LO(x4);
        GPR_TEST_LO(x4);  GPR_TEST_LO(x4);  GPR_TEST_LO(x4);  GPR_TEST_LO(x4);
        GPR_TEST_LO(x5);  GPR_TEST_LO(x5);  GPR_TEST_LO(x5);  GPR_TEST_LO(x5);
        GPR_TEST_LO(x5);  GPR_TEST_LO(x5);  GPR_TEST_LO(x5);  GPR_TEST_LO(x5);
        GPR_TEST_LO(x6);  GPR_TEST_LO(x6);  GPR_TEST_LO(x6);  GPR_TEST_LO(x6);
        GPR_TEST_LO(x6);  GPR_TEST_LO(x6);  GPR_TEST_LO(x6);  GPR_TEST_LO(x6);
        GPR_TEST_LO(x7);  GPR_TEST_LO(x7);  GPR_TEST_LO(x7);  GPR_TEST_LO(x7);
        GPR_TEST_LO(x7);  GPR_TEST_LO(x7);  GPR_TEST_LO(x7);  GPR_TEST_LO(x7);
        GPR_TEST_LO(x8);  GPR_TEST_LO(x8);  GPR_TEST_LO(x8);  GPR_TEST_LO(x8);
        GPR_TEST_LO(x8);  GPR_TEST_LO(x8);  GPR_TEST_LO(x8);  GPR_TEST_LO(x8);
        GPR_TEST_LO(x9);  GPR_TEST_LO(x9);  GPR_TEST_LO(x9);  GPR_TEST_LO(x9);
        GPR_TEST_LO(x9);  GPR_TEST_LO(x9);  GPR_TEST_LO(x9);  GPR_TEST_LO(x9);
        GPR_TEST_LO(x10); GPR_TEST_LO(x10); GPR_TEST_LO(x10); GPR_TEST_LO(x10);
        GPR_TEST_LO(x10); GPR_TEST_LO(x10); GPR_TEST_LO(x10); GPR_TEST_LO(x10);
        GPR_TEST_LO(x11); GPR_TEST_LO(x11); GPR_TEST_LO(x11); GPR_TEST_LO(x11);
        GPR_TEST_LO(x11); GPR_TEST_LO(x11); GPR_TEST_LO(x11); GPR_TEST_LO(x11);
        GPR_TEST_LO(x12); GPR_TEST_LO(x12); GPR_TEST_LO(x12); GPR_TEST_LO(x12);
        GPR_TEST_LO(x12); GPR_TEST_LO(x12); GPR_TEST_LO(x12); GPR_TEST_LO(x12);
        GPR_TEST_LO(x13); GPR_TEST_LO(x13); GPR_TEST_LO(x13); GPR_TEST_LO(x13);
        GPR_TEST_LO(x13); GPR_TEST_LO(x13); GPR_TEST_LO(x13); GPR_TEST_LO(x13);
        GPR_TEST_LO(x14); GPR_TEST_LO(x14); GPR_TEST_LO(x14); GPR_TEST_LO(x14);
        GPR_TEST_LO(x14); GPR_TEST_LO(x14); GPR_TEST_LO(x14); GPR_TEST_LO(x14);
        GPR_TEST_LO(x15); GPR_TEST_LO(x15); GPR_TEST_LO(x15); GPR_TEST_LO(x15);
        GPR_TEST_LO(x15); GPR_TEST_LO(x15); GPR_TEST_LO(x15); GPR_TEST_LO(x15);

        # Load the base address of the memory region for upper registers
        # (x16-x31) into x15. x15 will be used as a pointer to store the test
        # results.
        la      x15,    UPPER_REGS

        # Test each of the upper 16 General Purpose Registers (x16-x31).
        GPR_TEST_HI(x16); GPR_TEST_HI(x16); GPR_TEST_HI(x16); GPR_TEST_HI(x16);
        GPR_TEST_HI(x16); GPR_TEST_HI(x16); GPR_TEST_HI(x16); GPR_TEST_HI(x16);
        GPR_TEST_HI(x17); GPR_TEST_HI(x17); GPR_TEST_HI(x17); GPR_TEST_HI(x17);
        GPR_TEST_HI(x17); GPR_TEST_HI(x17); GPR_TEST_HI(x17); GPR_TEST_HI(x17);
        GPR_TEST_HI(x18); GPR_TEST_HI(x18); GPR_TEST_HI(x18); GPR_TEST_HI(x18);
        GPR_TEST_HI(x18); GPR_TEST_HI(x18); GPR_TEST_HI(x18); GPR_TEST_HI(x18);
        GPR_TEST_HI(x19); GPR_TEST_HI(x19); GPR_TEST_HI(x19); GPR_TEST_HI(x19);
        GPR_TEST_HI(x19); GPR_TEST_HI(x19); GPR_TEST_HI(x19); GPR_TEST_HI(x19);
        GPR_TEST_HI(x20); GPR_TEST_HI(x20); GPR_TEST_HI(x20); GPR_TEST_HI(x20);
        GPR_TEST_HI(x20); GPR_TEST_HI(x20); GPR_TEST_HI(x20); GPR_TEST_HI(x20);
        GPR_TEST_HI(x21); GPR_TEST_HI(x21); GPR_TEST_HI(x21); GPR_TEST_HI(x21);
        GPR_TEST_HI(x21); GPR_TEST_HI(x21); GPR_TEST_HI(x21); GPR_TEST_HI(x21);
        GPR_TEST_HI(x22); GPR_TEST_HI(x22); GPR_TEST_HI(x22); GPR_TEST_HI(x22);
        GPR_TEST_HI(x22); GPR_TEST_HI(x22); GPR_TEST_HI(x22); GPR_TEST_HI(x22);
        GPR_TEST_HI(x23); GPR_TEST_HI(x23); GPR_TEST_HI(x23); GPR_TEST_HI(x23);
        GPR_TEST_HI(x23); GPR_TEST_HI(x23); GPR_TEST_HI(x23); GPR_TEST_HI(x23);
        GPR_TEST_HI(x24); GPR_TEST_HI(x24); GPR_TEST_HI(x24); GPR_TEST_HI(x24);
        GPR_TEST_HI(x24); GPR_TEST_HI(x24); GPR_TEST_HI(x24); GPR_TEST_HI(x24);
        GPR_TEST_HI(x25); GPR_TEST_HI(x25); GPR_TEST_HI(x25); GPR_TEST_HI(x25);
        GPR_TEST_HI(x25); GPR_TEST_HI(x25); GPR_TEST_HI(x25); GPR_TEST_HI(x25);
        GPR_TEST_HI(x26); GPR_TEST_HI(x26); GPR_TEST_HI(x26); GPR_TEST_HI(x26);
        GPR_TEST_HI(x26); GPR_TEST_HI(x26); GPR_TEST_HI(x26); GPR_TEST_HI(x26);
        GPR_TEST_HI(x27); GPR_TEST_HI(x27); GPR_TEST_HI(x27); GPR_TEST_HI(x27);
        GPR_TEST_HI(x27); GPR_TEST_HI(x27); GPR_TEST_HI(x27); GPR_TEST_HI(x27);
        GPR_TEST_HI(x28); GPR_TEST_HI(x28); GPR_TEST_HI(x28); GPR_TEST_HI(x28);
        GPR_TEST_HI(x28); GPR_TEST_HI(x28); GPR_TEST_HI(x28); GPR_TEST_HI(x28);
        GPR_TEST_HI(x29); GPR_TEST_HI(x29); GPR_TEST_HI(x29); GPR_TEST_HI(x29);
        GPR_TEST_HI(x29); GPR_TEST_HI(x29); GPR_TEST_HI(x29); GPR_TEST_HI(x29);
        GPR_TEST_HI(x30); GPR_TEST_HI(x30); GPR_TEST_HI(x30); GPR_TEST_HI(x30);
        GPR_TEST_HI(x30); GPR_TEST_HI(x30); GPR_TEST_HI(x30); GPR_TEST_HI(x30);
        GPR_TEST_HI(x31); GPR_TEST_HI(x31); GPR_TEST_HI(x31); GPR_TEST_HI(x31);
        GPR_TEST_HI(x31); GPR_TEST_HI(x31); GPR_TEST_HI(x31); GPR_TEST_HI(x31);

        # Terminate the simulation. The exit code (0) indicates success.
        EXIT(0)

################################################################################
# Macro Undefine : Undefine the local macro to prevent accidental use later.
################################################################################

#undef WR_HI
#undef WR_LO
#undef GPR_TEST_LO
#undef GPR_TEST_HI

################################################################################
# Data section for storing test results.
################################################################################

# The .data section is used for initialized data, but here we use .zero to
# reserve space that will be written to by the test.
.section .data
# Align the following data to an 8-byte boundary (2^3). This is good practice
# and often required for certain data types or instructions.
.align 3

# Symbol marking the beginning of the data region to be extracted.
TEST_DATA_BEGIN:
# Reserve space for the results of the lower 16 GPRs (x0-x15).
LOWER_REGS:
  .zero __riscv_xlen / 8 * 16 * 8
# Reserve space for the results of the upper 16 GPRs (x16-x31).
UPPER_REGS:
  .zero __riscv_xlen / 8 * 16 * 8
# Symbol marking the end of the data region.
TEST_DATA_END:
