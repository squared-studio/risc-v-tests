# Test for the JALR (Jump and Link Register) instruction.

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
    # --- Test Cases for JALR ---
    # JALR stores pc+4 in rd, then jumps to (rs1 + imm) & ~1.

    # Test case 1: Simple JALR with zero offset.
    # Jump to a label, store return address in ra.
    # t0 will be set to confirm execution path.
    li      t0,     0xDEADBEEF      # Sentinel value
    la      a0,     target_label_1  # Load target address into a0
    jalr    ra,     0(a0)           # Jump to target_label_1, store return address in ra
    li      t0,     0xCAFEBABE      # This instruction should be skipped by the JALR.

return_from_jalr_1:
    # We land here after returning from target_label_1.
    # Now, set up and run the second test case.
    j       test_case_2_setup

target_label_1:
    # If we are here, the JALR was successful.
    # Now use the return address in ra to jump back.
    # t1 will be set to confirm execution path.
    li      t1,     0x11223344      # Set t1 to its final value.
    jalr    zero,   0(ra)           # Jump back to return_from_jalr_1.
    li      t1,     0x55667788      # This instruction should be skipped by the JALR.

test_case_2_setup:
    # Test case 2: JALR with non-zero offset.
    # We will jump to target_label_2_actual, skipping the instruction at target_label_2_base.
    li      t3,     0x99887766      # Set t3 to its final value.
    la      a0,     target_label_2_base
    jalr    t2,     4(a0)           # Jump to a0+4 (target_label_2_actual), link to t2.
    li      t3,     0xAABBCCDD      # This instruction should be skipped by the JALR.

return_from_jalr_2:
    # We land here after returning from target_label_2_actual.
    # The test is complete and successful.
    j       test_end

target_label_2_base:
    li      t4,     0xCCDDFF00      # This instruction should be skipped by the JALR's offset.
target_label_2_actual:
    # If we are here, the JALR with offset was successful.
    # Now use the link register (t2) to jump back.
    jalr    zero,   0(t2)           # Jump back to return_from_jalr_2.
    li      t4,     0xBEEFFEED      # This instruction should be skipped by the JALR.

test_end:
    li      t0,     1

    # --- Test Completion ---
    fence
    li      a0,     1           # Use 1 to indicate success.
    la      a1,     tohost
    sw      a0,     0(a1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1          # t0 (x5) should be 1 if test passes
GPR06_FINAL_VALUE: .dword 0x11223344 # t1 (x6) is set in target_label_1.
GPR28_FINAL_VALUE: .dword 0xAABBCCDD # t3 (x28) is set before the second JALR.
GPR29_FINAL_VALUE: .dword 0x0CDDFF00 # t4 (x29) should be 0, as the instruction to modify it is skipped.
