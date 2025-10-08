# Test for the BNE (Branch if Not Equal) instruction.

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

    # --- Test Cases for BNE ---
    # BNE branches if rs1 != rs2

    # Test case 1: Branch taken (rs1 != rs2)
    # Should jump to branch_taken_1
    li      a0,     10
    li      a1,     5
    bne     a0,     a1,     branch_taken_1
    # If we reach here, the branch failed. Set t0 to 0 (already is) and jump to end.
    j       test_fail

branch_taken_1:
    # If we are here, the first branch was taken.
    # Now test a branch not taken.
    li      a0,     10
    li      a1,     10
    bne     a0,     a1,     branch_not_taken_2_fail
    # If we reach here, the branch was correctly NOT taken.
    j       branch_not_taken_2_pass

branch_not_taken_2_fail:
    # If we are here, the second branch was incorrectly taken.
    j       test_fail

branch_not_taken_2_pass:
    # If we are here, both branches behaved correctly.
    # Set t0 to 1 to indicate success.
    li      t0,     1
    j       test_end

test_fail:
    # t0 is already 0, so no need to set it.
    j       test_end

test_end:
    # Signal test completion to the host.
    # The value of t0 (0 for fail, 1 for pass) will be written to tohost.
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
