################################################################################
#
#  This is a test for the RISC-V 'addi' (Add Immediate) instruction.
#  It executes a series of 'addi' operations with various immediate values
#  and register combinations, storing the results in a dedicated data section.
#  The test passes if the program completes successfully. A verification script
#  would typically check the stored results against expected values.
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

# STORE_X31: A macro to store the value of a register to the memory location
# pointed to by x31, and then increment the x31 pointer. This is used to
# save the result of each test case. It's conditionally compiled for RV32
# (using 'sw') and RV64 (using 'sd').
#if __riscv_xlen == 64
#define STORE_X31(REG)                  \
        sd      REG,    0(x31);         \
        addi    x31,    x31,    8;
#else
#define STORE_X31(REG)                  \
        sw      REG,    0(x31);         \
        addi    x31,    x31,    4;
#endif

# ADDI: A wrapper macro that executes an 'addi' instruction and then
# immediately stores the result using the STORE_X31 macro.
#define ADDI(RD, RS, IMM)               \
        addi    RD,     RS,     IMM;    \
        STORE_X31(RD);

################################################################################
# Program Entry Point
################################################################################

_start:
        # Initialize x31 (t6) to be the pointer to the results data area.
        la      x31,    TEST_DATA_BEGIN

        # Test cases for the 'addi' instruction.
        # The results are stored sequentially in memory.

        # Basic positive and negative immediates.
        ADDI (x0, x0, 100);
        ADDI (x1, x0, -1);
        ADDI (x2, x1, 2);

        # Test with a zero immediate.
        ADDI (x3, x1, 0);
        ADDI (x4, x2, 0);

        # Test with boundary immediate values (12-bit signed).
        ADDI (x5, x0, 2047);
        ADDI (x6, x0, -2048);

        # Test register-to-register dependency (result is source for next op).
        ADDI (x7, x1, 0);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);

        # Test with small negative immediates.
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);

        # Test with small positive immediates.
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);

# Undefine the local macro to prevent accidental use later.
#undef ADDI
#undef STORE_X31

        # Exit the test with a success code (0).
        EXIT(0)

################################################################################
# Data section for storing test results.
################################################################################

# Data section for storing test results.
.section .data
.align 3
# Reserve space for 32 test results. The size of each result depends on
# the architecture's word length (__riscv_xlen).
TEST_DATA_BEGIN:
    .zero __riscv_xlen / 8 * 32
TEST_DATA_END:
