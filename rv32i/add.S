# Test for the ADD (Addition) instruction.

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
        # --- Test Cases for ADD ---

        # Test case 1: Writing to the zero register.
        # This should have no effect on the architectural state.
        li      a0,     10
        add     zero,   a0,   zero

        # Test case 2: Add a negative number to zero.
        # t1 = 0 + (-1) = -1
        addi    a0,     zero,   -1
        add     t1,     zero,   a0

        # Test case 3: Add a positive and a negative number.
        # t2 = t1 + a1 = -1 + 2 = 1
        addi    a1,     zero,   2
        add     t2,     t1,     a1

        # Test case 4: Add a positive number to zero.
        # t3 = 0 + 132 = 132
        addi    a2,     zero,   132
        add     t3,     zero,   a2

        # Test case 5: Add a negative number to zero (alternative).
        # t4 = 0 + (-133) = -133
        addi    a3,     zero,   -133
        add     t4,     zero,   a3

        # Test case 6: Add a positive and a negative number resulting in a positive.
        # t5 = t4 + a4 = -133 + 134 = 1
        addi    a4,     zero,   134
        add     t5,     t4,     a4

        # Test case 7: Add a large positive number to zero.
        # t6 = 0 + 1232 = 1232
        addi    a5,     zero,   1232
        add     t6,     zero,   a5

        # Signal test completion to the host.
        fence
        addi    a0,     zero,   1   # Use 1 to indicate success.
        la      t0,     tohost      # Load address of tohost.
        sw      a0,     0(t0)       # Write success code to tohost.
        fence

_forever_loop:
        # Infinite loop to halt the processor after the test is done.
        j       _forever_loop

.section .rodata
.align 3
# Expected final register values for verification.
# Note: For RV64, results are sign-extended to 64 bits.
GPR00_FINAL_VALUE: .dword 0         # x0 (zero) should always be 0.
GPR06_FINAL_VALUE: .dword -1        # t1 (x6) should be -1.
GPR07_FINAL_VALUE: .dword 1         # t2 (x7) should be 1.
GPR28_FINAL_VALUE: .dword 132       # t3 (x28) should be 132.
GPR29_FINAL_VALUE: .dword -133      # t4 (x29) should be -133.
GPR30_FINAL_VALUE: .dword 1         # t5 (x30) should be 1.
GPR31_FINAL_VALUE: .dword 1232      # t6 (x31) should be 1232.
