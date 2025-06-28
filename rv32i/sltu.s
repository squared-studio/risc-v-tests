# Test for the SLTU (Set Less Than Unsigned) instruction.

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
    # --- Test Cases for SLTU ---
    # SLTU performs unsigned comparison: rd = (rs1 < rs2) ? 1 : 0

    # Test case 1: rs1 < rs2 (positive)
    # t0 = (5 < 10) ? 1 : 0 = 1
    li      a0,     5
    li      a1,     10
    sltu    t0,     a0,     a1

    # Test case 2: rs1 == rs2
    # t1 = (10 < 10) ? 1 : 0 = 0
    li      a0,     10
    li      a1,     10
    sltu    t1,     a0,     a1

    # Test case 3: rs1 > rs2 (positive)
    # t2 = (15 < 10) ? 1 : 0 = 0
    li      a0,     15
    li      a1,     10
    sltu    t2,     a0,     a1

    # Test case 4: Negative (large unsigned) vs Positive
    # t3 = (-5 < 5) ? 1 : 0 = 0 (0xFFFFFFFB is not less than 5 unsigned)
    li      a0,     -5
    li      a1,     5
    sltu    t3,     a0,     a1

    # Test case 5: Positive vs Negative (large unsigned)
    # t4 = (5 < -5) ? 1 : 0 = 1 (5 is less than 0xFFFFFFFB unsigned)
    li      a0,     5
    li      a1,     -5
    sltu    t4,     a0,     a1

    # Test case 6: Negative vs Negative (rs1 < rs2 unsigned)
    # t5 = (-10 < -5) ? 1 : 0 = 1 (0xFFFFFFF6 is less than 0xFFFFFFFB unsigned)
    li      a0,     -10
    li      a1,     -5
    sltu    t5,     a0,     a1

    # Test case 7: Negative vs Negative (rs1 > rs2 unsigned)
    # t6 = (-5 < -10) ? 1 : 0 = 0 (0xFFFFFFFB is not less than 0xFFFFFFF6 unsigned)
    li      a0,     -5
    li      a1,     -10
    sltu    t6,     a0,     a1

    # Test case 8: Zero comparison
    # t28 = (0 < 5) ? 1 : 0 = 1
    li      a0,     0
    li      a1,     5
    sltu    gp,     a0,     a1

    # Test case 9: Positive vs Zero
    # tp = (5 < 0) ? 1 : 0 = 0
    li      a0,     5
    li      a1,     0
    sltu    tp,     a0,     a1

    # Test case 10: Zero vs Max Unsigned
    # s0 = (0 < -1) ? 1 : 0 = 1 (0 is less than 0xFFFFFFFF unsigned)
    li      a0,     0
    li      a1,     -1
    sltu    s0,     a0,     a1

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
GPR28_FINAL_VALUE: .dword 0         # t3 (x28)
GPR29_FINAL_VALUE: .dword 1         # t4 (x29)
GPR30_FINAL_VALUE: .dword 1         # t5 (x30)
GPR31_FINAL_VALUE: .dword 0         # t6 (x31)
GPR03_FINAL_VALUE: .dword 1         # gp (x3)
GPR04_FINAL_VALUE: .dword 0         # tp (x4)
GPR08_FINAL_VALUE: .dword 1         # s0 (x8)
