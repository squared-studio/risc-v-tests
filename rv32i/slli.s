# Test for the SLLI (Shift Left Logical Immediate) instruction.

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
    # --- Test Cases for SLLI ---
    # SLLI performs logical left shift by an immediate amount: rd = rs1 << shamt
    # shamt is 5 bits for RV32 (0-31).

    # Test case 1: Shift by a small positive amount
    # t0 = 0x1 << 2 = 0x4
    li      a0,     1
    slli    t0,     a0,     2

    # Test case 2: Shift by zero
    # t1 = 0xABCD << 0 = 0xABCD
    li      a0,     0xABCD
    slli    t1,     a0,     0

    # Test case 3: Shift by maximum amount (31 for RV32)
    # t2 = 0x1 << 31 = 0x80000000 (signed -2147483648)
    li      a0,     1
    slli    t2,     a0,     31

    # Test case 4: Shift a negative number (logical shift, so sign bit moves)
    # t3 = 0xFFFFFFFF << 1 = 0xFFFFFFFE (signed -2)
    li      a0,     -1
    slli    t3,     a0,     1

    # Test case 5: Shift a large number
    # t4 = 0x12345678 << 4 = 0x23456780
    li      a0,     0x12345678
    slli    t4,     a0,     4

    # Test case 6: Shift by an amount that would exceed XLEN (shamt is masked)
    # This is effectively `slli t5, a0, 1` because shamt is 5 bits.
    # t5 = 0x1 << 1 = 0x2
    li      a0,     1
    slli    t5,     a0,     33 # shamt will be 33 & 0x1F = 1

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
GPR05_FINAL_VALUE: .dword 4         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x80000000 # t2 (x7)
GPR28_FINAL_VALUE: .dword 0xFFFFFFFE # t3 (x28)
GPR29_FINAL_VALUE: .dword 0x23456780 # t4 (x29)
GPR30_FINAL_VALUE: .dword 2         # t5 (x30)
