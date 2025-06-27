# Test for the SLTIU (Set Less Than Immediate Unsigned) instruction.

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
    # --- Test Cases for SLTIU ---
    # SLTIU performs unsigned comparison with a sign-extended immediate: rd = (rs1 < imm) ? 1 : 0
    # The 12-bit immediate is sign-extended before the comparison.

    # Test case 1: rs1 < imm (positive)
    # t0 = (5 < 10) ? 1 : 0 = 1
    li      a0,     5
    sltiu   t0,     a0,     10

    # Test case 2: rs1 == imm
    # t1 = (10 < 10) ? 1 : 0 = 0
    li      a0,     10
    sltiu   t1,     a0,     10

    # Test case 3: rs1 > imm (positive)
    # t2 = (15 < 10) ? 1 : 0 = 0
    li      a0,     15
    sltiu   t2,     a0,     10

    # Test case 4: Special case with immediate 1
    # t3 = (0 < 1) ? 1 : 0 = 1. This is equivalent to `seqz` (set if equal to zero).
    li      a0,     0
    sltiu   t3,     a0,     1

    # Test case 5: Positive rs1 vs Negative immediate (large unsigned)
    # t4 = (5 < -1) ? 1 : 0 = 1 (5 is less than 0xFFFFFFFF unsigned)
    li      a0,     5
    sltiu   t4,     a0,     -1

    # Test case 6: Negative rs1 (large unsigned) vs Positive immediate
    # t5 = (-5 < 5) ? 1 : 0 = 0 (0xFFFFFFFB is not less than 5 unsigned)
    li      a0,     -5
    sltiu   t5,     a0,     5

    # --- Test Completion ---
    fence
    li      a0,     1
    la      t1,     tohost
    sw      a0,     0(t1)
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