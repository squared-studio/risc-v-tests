# Test for the SRLI (Shift Right Logical Immediate) instruction.

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
    # --- Test Cases for SRLI ---
    # SRLI performs logical right shift by an immediate: rd = rs1 >> shamt
    # shamt is 5 bits for RV32 (0-31). Zeros are shifted in.

    # Test case 1: Shift by a small positive amount
    # t0 = 0x8 >> 2 = 0x2
    li      a0,     8
    srli    t0,     a0,     2

    # Test case 2: Shift by zero
    # t1 = 0xABCD >> 0 = 0xABCD
    li      a0,     0xABCD
    srli    t1,     a0,     0

    # Test case 3: Shift by maximum amount (31 for RV32)
    # t2 = 0x80000000 >> 31 = 0x1
    li      a0,     0x80000000
    srli    t2,     a0,     31

    # Test case 4: Shift a large number
    # t3 = 0x12345678 >> 4 = 0x01234567
    li      a0,     0x12345678
    srli    t3,     a0,     4

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
GPR05_FINAL_VALUE: .dword 2         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 1         # t2 (x28)
GPR28_FINAL_VALUE: .dword 0x01234567 # t3 (x29)
