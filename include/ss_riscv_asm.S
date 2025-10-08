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

#-----------------------------------------------------------------------
# Pseudo-Random Number Generation Macros
#-----------------------------------------------------------------------
# These macros generate pseudo-random numbers at assembly time. This is
# useful for creating varied test patterns without requiring a runtime
# random number generator. The randomness is based on the preprocessor
# directives `__LINE__` and `__COUNTER__`, so the generated values are
# deterministic for a given compilation but vary based on where the
# macro is invoked in the code.

# RAND8: Generates a pseudo-random 8-bit value.
#define RAND8 (((__LINE__ * 453 + 4534) * (__COUNTER__ * 786 + 843)) & 0x0FF)


# RAND16: Generates a pseudo-random 16-bit value by concatenating two
# different 8-bit random values.
#define RAND16 (RAND8 << 8 | RAND8)

# RAND32: Generates a pseudo-random 32-bit value by concatenating two
# different 16-bit random values.
#define RAND32 (RAND16 << 16 | RAND16)

# RAND64: Generates a pseudo-random 64-bit value by concatenating two
# different 32-bit random values.
#define RAND64 (RAND32 << 32 | RAND32)

# RAND128: Generates a pseudo-random 128-bit value by concatenating two
# different 64-bit random values.
#define RAND128 (RAND64 << 64 | RAND64)

# RANDIMM: Generates a pseudo-random 12-bit immediate value suitable for
# I-type instructions. It uses the `%lo` assembler relocation function
# to extract the lower 12 bits of a 16-bit random number.
#define RANDIMM (%lo(RAND16))

# RAND: A convenience macro that generates a random number with a width
# matching the architecture's native register size (XLEN). It resolves to
# RAND64 on RV64 and RAND32 on RV32.
#if __riscv_xlen == 64
  #define RAND RAND64
#else
  #define RAND RAND32
#endif

#endif
