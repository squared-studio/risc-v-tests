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

#if __riscv_xlen == 64
        #define WR_HI(REG)                      \
                sd      REG,    0(x31);         \
                addi    x31,    x31,    8;
        #define WR_LO(REG)                      \
                sd      REG,    0(x15);         \
                addi    x15,    x15,    8;
#else
        #define WR_HI(REG)                      \
                sw      REG,    0(x31);         \
                addi    x31,    x31,    4;
        #define WR_LO(REG)                      \
                sw      REG,    0(x15);         \
                addi    x15,    x15,    4;
#endif


#define GPR_TEST_LO(REG)                        \
        li      REG,    PREPROCESSOR_RANDOM;    \
        WR_HI(REG);

#define GPR_TEST_HI(REG)                        \
        li      REG,    PREPROCESSOR_RANDOM;    \
        WR_LO(REG);

################################################################################
# Program Entry Point
################################################################################

_start:
        la      x31,    LOWER_REGS
        GPR_TEST_LO(x0);
        GPR_TEST_LO(x1);
        GPR_TEST_LO(x2);
        GPR_TEST_LO(x3);
        GPR_TEST_LO(x4);
        GPR_TEST_LO(x5);
        GPR_TEST_LO(x6);
        GPR_TEST_LO(x7);
        GPR_TEST_LO(x8);
        GPR_TEST_LO(x9);
        GPR_TEST_LO(x10);
        GPR_TEST_LO(x11);
        GPR_TEST_LO(x12);
        GPR_TEST_LO(x13);
        GPR_TEST_LO(x14);
        GPR_TEST_LO(x15);

        la      x15,    UPPER_REGS
        GPR_TEST_HI(x16);
        GPR_TEST_HI(x17);
        GPR_TEST_HI(x18);
        GPR_TEST_HI(x19);
        GPR_TEST_HI(x20);
        GPR_TEST_HI(x21);
        GPR_TEST_HI(x22);
        GPR_TEST_HI(x23);
        GPR_TEST_HI(x24);
        GPR_TEST_HI(x25);
        GPR_TEST_HI(x26);
        GPR_TEST_HI(x27);
        GPR_TEST_HI(x28);
        GPR_TEST_HI(x29);
        GPR_TEST_HI(x30);
        GPR_TEST_HI(x31);

        EXIT(0)

################################################################################
# Data section for storing test results.
################################################################################

.section .data
.align 3
# Reserve space for test results. Adjust the size as needed for your test.
TEST_DATA_BEGIN:
LOWER_REGS:
    .zero __riscv_xlen / 8 * 16
UPPER_REGS:
    .zero __riscv_xlen / 8 * 16
TEST_DATA_END:
