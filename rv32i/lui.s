# Test for the LUI (Load Upper Immediate) instruction.

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
        # Initialize registers to a known state (zero).
        # This ensures the test starts from a clean slate.
        li      t0,     0
        li      t1,     0
        li      t2,     0
        li      t3,     0

        # --- Test Cases for LUI ---
        # LUI places the 20-bit U-immediate into the upper 20 bits (31:12)
        # of the destination register and clears the lower 12 bits.

        # Test case 1: Small positive immediate.
        # t0 = 1 << 12 = 0x1000
        lui     t0,     1

        # Test case 2: A larger immediate.
        # t1 = 0xABCDE << 12 = 0xABCDE000
        lui     t1,     0xABCDE

        # Test case 3: Zero immediate.
        # t2 = 0 << 12 = 0x0
        lui     t2,     0

        # Test case 4: Maximum 20-bit immediate.
        # t3 = 0xFFFFF << 12 = 0xFFFFF000
        lui     t3,     0xFFFFF

        # Signal test completion to the host.
        fence
        addi    a0,     zero,   1   # Use 1 to indicate success.
        la      t4,     tohost      # Load address of tohost.
        sw      a0,     0(t4)       # Write success code to tohost.
        fence

_forever_loop:
        # Infinite loop to halt the processor after the test is done.
        j       _forever_loop

.section .rodata
.align 3
# Expected final register values for verification.
# Note: For RV64, the 32-bit result of LUI is sign-extended to 64 bits.
GPR00_FINAL_VALUE: .dword 0                     # x0 (zero) should always be 0.
GPR05_FINAL_VALUE: .dword 0x0000000000001000    # t0 (x5) = 0x1000, sign-extended.
GPR06_FINAL_VALUE: .dword 0xFFFFFFFFABCDE000    # t1 (x6) = 0xABCDE000, sign-extended.
GPR07_FINAL_VALUE: .dword 0x0000000000000000    # t2 (x7) = 0x0, sign-extended.
GPR28_FINAL_VALUE: .dword 0xFFFFFFFFFFFFF000    # t3 (x28) = 0xFFFFF000, sign-extended.
