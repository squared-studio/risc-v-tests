# Test for the EBREAK (Environment Breakpoint) instruction.

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
    # --- Test Cases for EBREAK ---
    # EBREAK is used to trigger a breakpoint exception, typically for debugging.
    # In a simple test harness, the primary goal is to ensure the instruction
    # is decoded and executed without causing an illegal instruction exception.
    # The exact behavior (e.g., debugger interaction) depends on the environment.

    # Initialize a register to indicate test status.
    # We will change this to 1 only if the EBREAK executes without trapping
    # as an illegal instruction and allows program continuation (e.g., if a
    # debugger is attached and continues, or if the environment ignores it).
    li      t0,     0   # t0 will be our success indicator

    # Test case 1: Execute EBREAK.
    # The simulator/environment should handle this. If it's not implemented
    # or causes an unhandled trap, the test might fail or hang.
    ebreak

    # If we reached here, the EBREAK instruction was decoded and handled
    # successfully by the environment, allowing execution to continue.
    li      t0,     1

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

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1         # t0 (x5) should be 1 if test passes
