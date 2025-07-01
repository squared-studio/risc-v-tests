################################################################################
#
#  This is a template for a RISC-V instruction test.
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
# Program Entry Point
################################################################################

_start:
        la      t0,     putchar_stdout  # t0 = address of stdout for printing
        la      a0,     hello_string    # a0 = pointer to the string to print
        la      a1,     TEST_DATA_BEGIN # a1 = pointer to the test data region for verification

print_loop:
        lb      t1,     0(a0)           # Load a character from the string into t1
        sb      t1,     0(t0)           # Write the character to stdout to print it
        sb      t1,     0(a1)           # Store the character in the test data region
        addi    a0,     a0,     1       # Move to the next character in the string
        addi    a1,     a1,     1       # Move to the next byte in the test data region
        beqz    t1,     end_program     # If the character is null (end of string), exit the loop
        j       print_loop              # Repeat for the next character

end_program:
        EXIT(0) # exit code 0

################################################################################
# Data section for storing test results.
################################################################################

.section .data
.align 3 # Align to an 8-byte boundary

# This region is used to store a copy of the output for later verification.
# The test framework can then read this memory region to confirm the test passed.
TEST_DATA_BEGIN:
  .zero 16
TEST_DATA_END:

# The string to be printed to standard output.
hello_string: .asciz "Hello World!\n"

# This symbol represents the memory-mapped address for character output.
# In a simulation environment like Spike, writing a byte to this address
# will print the character to the host's console.
.align 3 # Align to an 8-byte boundary
.global putchar_stdout
putchar_stdout:
  .byte 0
