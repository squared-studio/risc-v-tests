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
    li      t0,     0xDEADBEEF # Sentinel value
    la      a0,     target_label_1 # Load target address into a0
    jalr    ra,     0(a0)      # Jump to target_label_1, store return address in ra
    li      t0,     0xCAFEBABE # This instruction should NOT be executed

target_label_1:
    # If we are here, the JALR was successful.
    # Now use the return address in ra to jump back.
    # t1 will be set to confirm execution path.
    li      t1,     0x11223344 # Sentinel value
    jalr    zero,   0(ra)      # Jump back to after the first JALR
    li      t1,     0x55667788 # This instruction should NOT be executed

    # Test case 2: JALR with non-zero offset.
    # Jump to a label + offset, store return address in t2.
    # t3 will be set to confirm execution path.
    li      t3,     0x99887766 # Sentinel value
    la      a0,     target_label_2_base
    addi    a0,     a0,     4 # Adjust base address to point to target_label_2_actual
    jalr    t2,     -4(a0)     # Jump to (a0 - 4), which is target_label_2_base
    li      t3,     0xAABBCCDD # This instruction should NOT be executed

target_label_2_base:
    li      t4,     0xCCDDFF00 # This instruction should be skipped by the jump
target_label_2_actual:
    # If we are here, the JALR with offset was successful.
    # t4 should NOT have the value 0xCCDDFF00.
    # Set t0 to 1 to indicate overall success.
    li      t0,     1

    # --- Test Completion ---
    fence
    li      a0,     1           # Use 1 to indicate success.
    la      t1,     tohost
    sw      a0,     0(t1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 1         # t0 (x5) should be 1 if test passes
GPR06_FINAL_VALUE: .dword 0x11223344 # t1 (x6) should retain its initial value
GPR28_FINAL_VALUE: .dword 0x99887766 # t3 (x28) should retain its initial value
GPR29_FINAL_VALUE: .dword 0xCCDDFF00 # t4 (x29) should retain its initial value (meaning it was skipped)
