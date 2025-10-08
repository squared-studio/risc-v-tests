# Test for the SLL (Shift Left Logical) instruction.

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
    # --- Test Cases for SLL ---
    # SLL performs logical left shift: rd = rs1 << rs2[4:0] (for RV32)

    # Test case 1: Shift by a small positive amount
    # t0 = 0x1 << 2 = 0x4
    li      a0,     1
    li      a1,     2
    sll     t0,     a0,     a1

    # Test case 2: Shift by zero
    # t1 = 0xABCD << 0 = 0xABCD
    li      a0,     0xABCD
    li      a1,     0
    sll     t1,     a0,     a1

    # Test case 3: Shift by maximum amount (31 for RV32)
    # t2 = 0x1 << 31 = 0x80000000 (signed -2147483648)
    li      a0,     1
    li      a1,     31
    sll     t2,     a0,     a1

    # Test case 4: Shift a negative number (logical shift, so sign bit moves)
    # t3 = 0xFFFFFFFF << 1 = 0xFFFFFFFE (signed -2)
    li      a0,     -1
    li      a1,     1
    sll     t3,     a0,     a1

    # Test case 5: Shift a large number
    # t4 = 0x01234567 << 4 = 0x12345670
    li      a0,     0x01234567
    li      a1,     4
    sll     t4,     a0,     a1

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
GPR05_FINAL_VALUE: .dword 4         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x80000000 # t2 (x7)
GPR28_FINAL_VALUE: .dword 0xFFFFFFFFFFFFFFFE # t3 (x28)
GPR29_FINAL_VALUE: .dword 0x12345670 # t4 (x29)
