# Test for the OR (Bitwise OR) instruction.

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
    # --- Test Cases for OR ---
    # OR performs bitwise OR: rd = rs1 | rs2

    # Test case 1: Simple OR
    # t0 = 0b1010 | 0b0110 = 0b1110 (10 | 6 = 14)
    li      a0,     10      # 0xA
    li      a1,     6       # 0x6
    or      t0,     a0,     a1

    # Test case 2: OR with zero
    # t1 = 0xABCD | 0 = 0xABCD
    li      a0,     0xABCD
    li      a1,     0
    or      t1,     a0,     a1

    # Test case 3: OR with all ones (-1)
    # t2 = 0x12345678 | 0xFFFFFFFF = 0xFFFFFFFF
    li      a0,     0x12345678
    li      a1,     -1
    or      t2,     a0,     a1

    # Test case 4: OR identical values
    # t3 = 0x5555 | 0x5555 = 0x5555
    li      a0,     0x5555
    li      a1,     0x5555
    or      t3,     a0,     a1

    # Test case 5: OR with negative numbers
    # t4 = -10 | -5
    # -10 = 0xFFFFFFF6
    # -5  = 0xFFFFFFFB
    # OR  = 0xFFFFFFFB (-5)
    li      a0,     -10
    li      a1,     -5
    or      t4,     a0,     a1

    # --- Test Completion ---
    fence
    li      a0,     1
    la      t0,     tohost
    sw      a0,     0(t0)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 14        # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0xFFFFFFFF # t2 (x7)
GPR28_FINAL_VALUE: .dword 0x5555    # t3 (x28)
GPR29_FINAL_VALUE: .dword 0xFFFFFFFB # t4 (x29)
