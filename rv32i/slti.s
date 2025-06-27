# Test for the SLTI (Set Less Than Immediate) instruction.

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
    # --- Test Cases for SLTI ---
    # SLTI performs signed comparison with immediate: rd = (rs1 < imm) ? 1 : 0

    # Test case 1: rs1 < imm (positive)
    # t0 = (5 < 10) ? 1 : 0 = 1
    li      a0,     5
    slti    t0,     a0,     10

    # Test case 2: rs1 == imm
    # t1 = (10 < 10) ? 1 : 0 = 0
    li      a0,     10
    slti    t1,     a0,     10

    # Test case 3: rs1 > imm (positive)
    # t2 = (15 < 10) ? 1 : 0 = 0
    li      a0,     15
    slti    t2,     a0,     10

    # Test case 4: Negative rs1 vs Positive imm
    # t3 = (-5 < 5) ? 1 : 0 = 1
    li      a0,     -5
    slti    t3,     a0,     5

    # Test case 5: Positive rs1 vs Negative imm
    # t4 = (5 < -5) ? 1 : 0 = 0
    li      a0,     5
    slti    t4,     a0,     -5

    # Test case 6: Negative rs1 vs Negative imm (rs1 < imm)
    # t5 = (-10 < -5) ? 1 : 0 = 1
    li      a0,     -10
    slti    t5,     a0,     -5

    # Test case 7: Negative rs1 vs Negative imm (rs1 > imm)
    # t6 = (-5 < -10) ? 1 : 0 = 0
    li      a0,     -5
    slti    t6,     a0,     -10

    # Test case 8: Zero comparison
    # t28 = (0 < 5) ? 1 : 0 = 1
    li      a0,     0
    slti    t28,    a0,     5

    # Test case 9: Zero comparison (negative)
    # t29 = (-5 < 0) ? 1 : 0 = 1
    li      a0,     -5
    slti    t29,    a0,     0

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
GPR05_FINAL_VALUE: .dword 1         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0         # t1 (x6)
GPR07_FINAL_VALUE: .dword 0         # t2 (x7)
GPR28_FINAL_VALUE: .dword 1         # t3 (x28)
GPR29_FINAL_VALUE: .dword 0         # t4 (x29)
GPR30_FINAL_VALUE: .dword 1         # t5 (x30)
GPR31_FINAL_VALUE: .dword 0         # t6 (x31)
GPR03_FINAL_VALUE: .dword 1         # t28 (x3)
GPR04_FINAL_VALUE: .dword 1         # t29 (x4)
