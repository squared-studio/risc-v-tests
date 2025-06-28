# Test for the AND (Bitwise AND) instruction.

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
    # --- Test Cases for AND ---
    # AND performs bitwise AND: rd = rs1 & rs2

    # Test case 1: Simple AND
    # t0 = 0b1111 & 0b1010 = 0b1010 (15 & 10 = 10)
    li      a0,     15      # 0xF
    li      a1,     10      # 0xA
    and     t0,     a0,     a1

    # Test case 2: AND with zero
    # t1 = 0xABCD & 0 = 0
    li      a0,     0xABCD
    li      a1,     0
    and     t1,     a0,     a1

    # Test case 3: AND with all ones (-1)
    # t2 = 0x12345678 & 0xFFFFFFFF = 0x12345678
    li      a0,     0x12345678
    li      a1,     -1
    and     t2,     a0,     a1

    # Test case 4: AND identical values
    # t3 = 0x5555 & 0x5555 = 0x5555
    li      a0,     0x5555
    li      a1,     0x5555
    and     t3,     a0,     a1

    # Test case 5: AND with negative numbers
    # t4 = -10 & -5
    # -10 = 0xFFFFFFF6
    # -5  = 0xFFFFFFFB
    # AND = 0xFFFFFFF2 (-14)
    li      a0,     -10
    li      a1,     -5
    and     t4,     a0,     a1

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
GPR05_FINAL_VALUE: .dword 10        # t0 (x5)
GPR06_FINAL_VALUE: .dword 0         # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x12345678 # t2 (x7)
GPR28_FINAL_VALUE: .dword 0x5555    # t3 (x28)
GPR29_FINAL_VALUE: .dword -14       # t4 (x29)
