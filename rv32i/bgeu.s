# Test for the BGEU (Branch if Greater than or Equal Unsigned) instruction.

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
    li      t0,     0   # t0 will be our success indicator

    # --- Test Cases for BGEU ---
    # BGEU branches if rs1 >= rs2 (unsigned)

    # Test case 1: Branch taken (10 >= 5)
    li      a0,     10
    li      a1,     5
    bgeu    a0,     a1,     pass_1
    j       test_fail

pass_1:
    # Test case 2: Branch taken (10 >= 10)
    li      a0,     10
    li      a1,     10
    bgeu    a0,     a1,     pass_2
    j       test_fail

pass_2:
    # Test case 3: Branch not taken (5 >= 10)
    li      a0,     5
    li      a1,     10
    bgeu    a0,     a1,     test_fail
    j       pass_3

pass_3:
    # Test case 4: Branch taken (-5 (large unsigned) >= 5 (small unsigned))
    li      a0,     -5
    li      a1,     5
    bgeu    a0,     a1,     pass_4
    j       test_fail

pass_4:
    # Test case 5: Branch not taken (5 (small unsigned) >= -5 (large unsigned))
    li      a0,     5
    li      a1,     -5
    bgeu    a0,     a1,     test_fail
    j       pass_5

pass_5:
    # Test case 6: Branch taken (-5 (large unsigned) >= -10 (large unsigned))
    li      a0,     -5
    li      a1,     -10
    bgeu    a0,     a1,     pass_6
    j       test_fail

pass_6:
    # Test case 7: Branch not taken (-10 (large unsigned) >= -5 (large unsigned))
    li      a0,     -10
    li      a1,     -5
    bgeu    a0,     a1,     test_fail
    j       all_tests_passed

all_tests_passed:
    # All branches behaved correctly.
    li      t0,     1
    j       test_end

test_fail:
    j       test_end

test_end:
    # Signal test completion to the host.
    fence
    mv      a0,     t0
    la      t1,     tohost
    sw      a0,     0(t1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1         # t0 (x5) should be 1 if test passes