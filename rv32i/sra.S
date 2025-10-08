# Test for the SRA (Shift Right Arithmetic) instruction.

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
    # --- Test Cases for SRA ---
    # SRA performs arithmetic right shift: rd = rs1 >> rs2[4:0]
    # The sign bit is replicated.

    # Test case 1: Shift a positive number
    # t0 = 0x8 >> 2 = 0x2
    li      a0,     8
    li      a1,     2
    sra     t0,     a0,     a1

    # Test case 2: Shift by zero
    # t1 = 0xABCD >> 0 = 0xABCD
    li      a0,     0xABCD
    li      a1,     0
    sra     t1,     a0,     a1

    # Test case 3: Shift a negative number (arithmetic shift, so sign bit is preserved)
    # t2 = 0xFFFFFFFF >> 1 = 0xFFFFFFFF (-1)
    li      a0,     -1
    li      a1,     1
    sra     t2,     a0,     a1

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
GPR07_FINAL_VALUE: .dword 0xFFFFFFFFFFFFFFFF # t2 (x7)
