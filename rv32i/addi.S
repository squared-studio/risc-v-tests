# Test for the ADDI (Add Immediate) instruction.

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
        # --- Test Cases for ADDI ---
        # ADDI adds a signed 12-bit immediate to a register.

        # Test case 1: Writing to the zero register.
        # This should have no effect (zero register always holds 0).
        addi    zero,   zero,   1   # zero = 0 + 1 (but zero remains 0)

        # Test case 2: Add a negative immediate to zero.
        # t1 = 0 + (-1) = -1
        addi    t1,     zero,   -1

        # Test case 3: Add a positive immediate to a negative register.
        # t2 = t1 + 2 = -1 + 2 = 1
        addi    t2,     t1,     2

        # Test case 4: Add a positive immediate to zero.
        # t3 = 0 + 132 = 132
        addi    t3,     zero,   132

        # Test case 5: Add a negative immediate to zero.
        # t4 = 0 + (-133) = -133
        addi    t4,     zero,   -133

        # Test case 6: Add a positive immediate to a negative register, result is positive.
        # t5 = t4 + 134 = -133 + 134 = 1
        addi    t5,     t4,     134

        # Test case 7: Add a large positive immediate to zero.
        # t6 = 0 + 1232 = 1232
        addi    t6,     zero,   1232

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
GPR00_FINAL_VALUE: .dword 0         # x0 (zero) should always be 0.
GPR06_FINAL_VALUE: .dword -1        # t1 (x6) should be -1.
GPR07_FINAL_VALUE: .dword 1         # t2 (x7) should be 1.
GPR28_FINAL_VALUE: .dword 132       # t3 (x28) should be 132.
GPR29_FINAL_VALUE: .dword -133      # t4 (x29) should be -133.
GPR30_FINAL_VALUE: .dword 1         # t5 (x30) should be 1.
GPR31_FINAL_VALUE: .dword 1232      # t6 (x31) should be 1232.
