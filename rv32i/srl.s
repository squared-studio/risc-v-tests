# Test for the SRL (Shift Right Logical) instruction.

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
    # --- Test Cases for SRL ---
    # SRL performs logical right shift: rd = rs1 >> rs2[4:0] (for RV32)
    # Zeros are shifted into the most significant bits.

    # Test case 1: Shift by a small positive amount
    # t0 = 0x8 >> 2 = 0x2
    li      a0,     8
    li      a1,     2
    srl     t0,     a0,     a1

    # Test case 2: Shift by zero
    # t1 = 0xABCD >> 0 = 0xABCD
    li      a0,     0xABCD
    li      a1,     0
    srl     t1,     a0,     a1

    # Test case 3: Shift a negative number (logical shift, so sign bit becomes 0)
    # t2 = 0xFFFFFFFF >> 1 = 0x7FFFFFFF
    li      a0,     -1
    li      a1,     1
    srl     t2,     a0,     a1

    # Test case 4: Shift by maximum amount (31 for RV32)
    # t3 = 0x80000000 >> 31 = 0x1
    li      a0,     0x80000000
    li      a1,     31
    srl     t3,     a0,     a1

    # Test case 5: Shift a large number
    # t4 = 0x12345678 >> 4 = 0x01234567
    li      a0,     0x12345678
    li      a1,     4
    srl     t4,     a0,     a1

    # Test case 6: Shift by more than XLEN (should only use lower 5 bits of shamt)
    # t5 = 0x10 >> 33 (shamt is 33, but only 33 & 0x1F = 1 is used) = 0x8
    li      a0,     0x10
    li      a1,     33
    srl     t5,     a0,     a1

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
GPR05_FINAL_VALUE: .dword 2         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x7FFFFFFF # t2 (x7)
GPR28_FINAL_VALUE: .dword 1         # t3 (x28)
GPR29_FINAL_VALUE: .dword 0x01234567 # t4 (x29)
GPR30_FINAL_VALUE: .dword 8         # t5 (x30)
