# Test for the FENCE instruction.

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
    # --- Test Cases for FENCE ---
    # In a single-hart environment, the primary goal of this test is to ensure
    # that various forms of the FENCE instruction are decoded and executed
    # without causing an illegal instruction exception.
    # A true test of memory ordering semantics would require a multi-hart
    # environment to observe potential reordering.

    # Initialize a register to indicate test status.
    # We will change this to 1 only if all instructions execute without trapping.
    li      t0,     0   # t0 will be our success indicator

    # Execute a series of FENCE instructions with different operands.
    # If any of these cause a trap, the code will not reach the success marker.

    # Test case 1: Default FENCE (alias for FENCE IORW, IORW)
    fence

    # Test case 2: FENCE.I - Instruction stream fence
    fence.i

    # Test case 3: FENCE R, R - Order reads before reads
    fence r, r

    # Test case 4: FENCE W, W - Order writes before writes
    fence w, w

    # Test case 5: FENCE RW, RW - Order reads/writes before reads/writes
    fence rw, rw

    # Test case 6: FENCE I, O - Order I/O reads before I/O writes
    fence i, o

    # If we reached here, all FENCE instructions were decoded successfully.
    li      t0,     1

    # --- Test Completion ---
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
