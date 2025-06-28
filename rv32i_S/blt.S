# Test for the BLT (Branch if Less Than) instruction.

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
    # Initialize a register to indicate test status.
    # We'll set it to 0 initially, and change it to 1 if all branches pass.
    li      t0,     0   # t0 will be our success indicator

    # --- Test Cases for BLT ---
    # BLT branches if rs1 < rs2 (signed comparison)

    # Test case 1: Branch taken (positive rs1 < rs2)
    li      a0,     5
    li      a1,     10
    blt     a0,     a1,     branch_taken_1
    j       test_fail # Should not reach here

branch_taken_1:
    # Test case 2: Branch not taken (positive rs1 == rs2)
    li      a0,     10
    li      a1,     10
    blt     a0,     a1,     branch_not_taken_2_fail
    j       branch_not_taken_2_pass # Should reach here

branch_not_taken_2_fail:
    j       test_fail # Should not reach here

branch_not_taken_2_pass:
    # Test case 3: Branch not taken (positive rs1 > rs2)
    li      a0,     15
    li      a1,     10
    blt     a0,     a1,     branch_not_taken_3_fail
    j       branch_not_taken_3_pass # Should reach here

branch_not_taken_3_fail:
    j       test_fail # Should not reach here

branch_not_taken_3_pass:
    # Test case 4: Branch taken (negative rs1 < rs2)
    li      a0,     -10
    li      a1,     -5
    blt     a0,     a1,     branch_taken_4
    j       test_fail # Should not reach here

branch_taken_4:
    # Test case 5: Branch not taken (negative rs1 > rs2)
    li      a0,     -5
    li      a1,     -10
    blt     a0,     a1,     branch_not_taken_5_fail
    j       branch_not_taken_5_pass # Should reach here

branch_not_taken_5_fail:
    j       test_fail # Should not reach here

branch_not_taken_5_pass:
    # All branches behaved correctly.
    li      t0,     1
    j       test_end

test_fail:
    # t0 is already 0, so no need to set it.
    j       test_end

test_end:
    # Signal test completion to the host.
    fence
    mv      a0,     t0          # Move success indicator to a0
    la      t1,     tohost
    sw      a0,     0(t1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1         # t0 (x5) should be 1 if test passes
