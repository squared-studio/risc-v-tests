################################################################################
#
#  This is a template for a RISC-V instruction test.
#  Author: Name (email)
#
#  This file is part of squared-studio:risc-v-tests
#  Copyright (c) YYYY squared-studio
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

#define EXAMPLE_MACRO_ADD(A, B) (A + B)

################################################################################
# Program Entry Point
################################################################################

_start:
        # Add test codes here
        # Example:
        li      a0,     10              # a0 = 10
        li      a1,     20              # a1 = 20
        li      a2,     30              # a2 = 30
        add     a3,     a0,     a1      # a3 = a0 + a1 = 10 + 20 = 30

        la      t0,     TEST_DATA_BEGIN # t0 = TEST_DATA_BEGIN

#if __riscv_xlen == 64
        sd      a0,     0(t0)   # mem[TEST_DATA_BEGIN + 0] = a0
        sd      a1,     8(t0)   # mem[TEST_DATA_BEGIN + 8] = a1
        sd      a2,     16(t0)  # mem[TEST_DATA_BEGIN + 16] = a2
        sd      a3,     24(t0)  # mem[TEST_DATA_BEGIN + 24] = a3
#else
        sw      a0,     0(t0)   # mem[TEST_DATA_BEGIN + 0] = a0
        sw      a1,     4(t0)   # mem[TEST_DATA_BEGIN + 4] = a1
        sw      a2,     8(t0)   # mem[TEST_DATA_BEGIN + 8] = a2
        sw      a3,     12(t0)  # mem[TEST_DATA_BEGIN + 12] = a3
#endif

################################################################################
        # Simply exit with a constant code
        beq     a3,     a2,     pass    # if a3 == a2, pass; else, fail
fail:
        EXIT(1) # exit code 1
pass:
        EXIT(0) # exit code 0
################################################################################

        # Alternatively, grab the exit code form a register
        beq     a3,     a2,     success # if a3 == a2, success; else, failure
failure:
        li      t0,     1       # load 1
        j       exit            # jump to exit
success:
        li      t0,     0       # load 0
        j       exit            # jump to exit
exit:
        EXIT_R(t0)              # exit code from reg t0

################################################################################
# Macro Undefine : Undefine the local macro to prevent accidental use later.
################################################################################

#undef EXAMPLE_MACRO_ADD

################################################################################
# Data section for storing test results.
################################################################################

.section .data
.align 3
# Reserve space for test results. Adjust the size as needed for your test.
TEST_DATA_BEGIN:
  .zero __riscv_xlen / 8 * 4
TEST_DATA_END:
