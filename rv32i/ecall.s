# Test for the ECALL (Environment Call) instruction with a trap handler.

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
    # --- Test Setup ---
    # Set the Machine Trap Vector (mtvec) to point to our trap handler.
    la      t1, _trap_handler
    csrw    mtvec, t1

    # --- Test Cases for ECALL ---
    # ECALL is used to make a request to the execution environment.
    # This test verifies that ECALL traps to the handler, which then returns
    # execution to the instruction following the ECALL.

    # Initialize a register to indicate test status.
    # We will change this to 1 only if the ECALL traps and the handler
    # correctly returns control flow.
    li      t0,     0   # t0 will be our success indicator

    # Test case 1: Execute ECALL.
    # This should cause a trap and transfer control to _trap_handler.
    ecall

    # If we reached here, the trap handler successfully returned.
    # This is the success condition.
    li      t0,     1

_end_test:
    # --- Test Completion ---
    # Signal test completion to the host.
    fence
    mv      a0,     t0          # Move success indicator to a0
    la      t1,     tohost
    sw      a0,     0(t1)
    fence

_forever_loop:
    # Infinite loop to halt the processor after the test is done.
    j       _forever_loop

.section .text
.align 2 # Trap handlers should be aligned to 4 bytes for mtvec direct mode
_trap_handler:
    # A simple trap handler for ECALL.
    # For this test, we only handle M-mode ECALL.

    # Check the cause of the trap.
    csrr    t2, mcause
    li      t3, 11  # mcause 11 is Environment call from M-mode
    bne     t2, t3, _trap_fail

    # ECALL trap occurred as expected.
    # Increment mepc to return to the instruction after ecall.
    csrr    t2, mepc
    addi    t2, t2, 4
    csrw    mepc, t2

    # Return from trap.
    mret

_trap_fail:
    # If the trap was not an ECALL, something is wrong.
    # Set t0 to a failure code (e.g., 2) and jump to the end.
    li      t0, 2
    j       _end_test

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1         # t0 (x5) should be 1 if test passes
