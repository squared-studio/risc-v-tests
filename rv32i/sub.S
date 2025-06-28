# Test for the SUB (Subtraction) instruction.

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

.section .text
.align 3
.global _start
_start:
    # --- Test Cases for SUB ---
    # SUB performs subtraction: rd = rs1 - rs2

    # Test case 1: Positive - Positive
    # t0 = 10 - 5 = 5
    li      a0,     10
    li      a1,     5
    sub     t0,     a0,     a1

    # Test case 2: Positive - Negative
    # t1 = 10 - (-5) = 15
    li      a0,     10
    li      a1,     -5
    sub     t1,     a0,     a1

    # Test case 3: Negative - Positive
    # t2 = -10 - 5 = -15
    li      a0,     -10
    li      a1,     5
    sub     t2,     a0,     a1

    # Test case 4: Negative - Negative
    # t3 = -10 - (-5) = -5
    li      a0,     -10
    li      a1,     -5
    sub     t3,     a0,     a1

    # Test case 5: Zero result
    # t4 = 7 - 7 = 0
    li      a0,     7
    li      a1,     7
    sub     t4,     a0,     a1

    # Test case 6: Subtract from zero
    # t5 = 0 - 100 = -100
    li      a0,     0
    li      a1,     100
    sub     t5,     a0,     a1

    # --- Test Completion ---
    fence
    li      a0,     1
    la      a1,     tohost
    sw      a0,     0(a1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 5         # t0 (x5)
GPR06_FINAL_VALUE: .dword 15        # t1 (x6)
GPR07_FINAL_VALUE: .dword -15       # t2 (x7)
GPR28_FINAL_VALUE: .dword -5        # t3 (x28)
GPR29_FINAL_VALUE: .dword 0         # t4 (x29)
GPR30_FINAL_VALUE: .dword -100      # t5 (x30)
