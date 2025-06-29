#ifndef __GUARD_SS_RISCV_ASM_S__
#define __GUARD_SS_RISCV_ASM_S__

# This header file provides macros and definitions for bare-metal RISC-V
# assembly tests, primarily for use in simulation environments like Spike.

# Data section
.section .data

# 'tohost' and 'fromhost' are special symbols used for communication with the
# host environment (the simulator). Writing to 'tohost' is the standard way
# for a bare-metal program to signal events, such as test completion, to the host.
.align 3
.global tohost
tohost: .word 0
.align 3
.global fromhost
fromhost: .word 0

# Text (code) section
.section .text
# Align to 8-byte boundary (2^3)
.align 3
# The '_start' symbol is the conventional entry point for execution in
# bare-metal environments. The linker will use this as the program's
# starting address.
.global _start

# EXIT_R: A low-level macro to terminate the simulation via the 'tohost' symbol.
# It encodes the exit code from the source register and writes it to 'tohost'.
# The encoding `(exit_code << 1) | 1` signals test completion to simulators
# like Spike. After writing to 'tohost', the macro enters an infinite loop to
# halt execution.
# Utilizes t0, t1, t2.
# @param REG Register holding the raw exit code.
#define EXIT_R(REG)                     \
        fence;                          \
        addi    t0,     REG,    0;      \
        la      t1,     tohost;         \
        slli    t0,     t0,     1;      \
        ori     t0,     t0,     1;      \
        sw      t0,     0(t1);          \
        fence;                          \
        auipc   t2,     0;              \
        jalr    x0,     0(t2);

# EXIT: A convenience macro to exit the test with a given code.
# A code of 0 indicates success. Any other code indicates failure.
# @param CODE The immediate exit code.
#define EXIT(CODE)                      \
        li      t0,     CODE;           \
        EXIT_R(t0);

#endif
