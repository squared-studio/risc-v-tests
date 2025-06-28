# Test for the SLT (Set Less Than) instruction.

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
    # --- Test Cases for SLT ---
    # SLT performs signed comparison: rd = (rs1 < rs2) ? 1 : 0

    # Test case 1: rs1 < rs2 (positive)
    # t0 = (5 < 10) ? 1 : 0 = 1
    li      a0,     5
    li      a1,     10
    slt     t0,     a0,     a1

    # Test case 2: rs1 == rs2
    # t1 = (10 < 10) ? 1 : 0 = 0
    li      a0,     10
    li      a1,     10
    slt     t1,     a0,     a1

    # Test case 3: rs1 > rs2 (positive)
    # t2 = (15 < 10) ? 1 : 0 = 0
    li      a0,     15
    li      a1,     10
    slt     t2,     a0,     a1

    # Test case 4: Negative vs Positive
    # t3 = (-5 < 5) ? 1 : 0 = 1
    li      a0,     -5
    li      a1,     5
    slt     t3,     a0,     a1

    # Test case 5: Negative vs Negative (rs1 < rs2)
    # t4 = (-10 < -5) ? 1 : 0 = 1
    li      a0,     -10
    li      a1,     -5
    slt     t4,     a0,     a1

    # Test case 6: Negative vs Negative (rs1 > rs2)
    # t5 = (-5 < -10) ? 1 : 0 = 0
    li      a0,     -5
    li      a1,     -10
    slt     t5,     a0,     a1

    # Test case 7: Zero comparison
    # t6 = (0 < 5) ? 1 : 0 = 1
    li      a0,     0
    li      a1,     5
    slt     t6,     a0,     a1

    # Test case 8: Zero comparison (negative)
    # t3 = (-5 < 0) ? 1 : 0 = 1
    li      a0,     -5
    li      a1,     0
    slt     t3,    a0,     a1

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
GPR05_FINAL_VALUE: .dword 1         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0         # t1 (x6)
GPR07_FINAL_VALUE: .dword 0         # t2 (x7)
GPR28_FINAL_VALUE: .dword 1         # t3 (x28)
GPR29_FINAL_VALUE: .dword 1         # t4 (x29)
GPR30_FINAL_VALUE: .dword 0         # t5 (x30)
GPR31_FINAL_VALUE: .dword 1         # t6 (x31)
GPR03_FINAL_VALUE: .dword 1         # t28 (x3)
