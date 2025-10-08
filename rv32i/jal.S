# Test for the JAL (Jump and Link) instruction.

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
    # --- Test Cases for JAL ---
    # JAL stores pc+4 in rd, then jumps to pc + imm.
    # Default rd is x1 (ra).

    # Test case 1: Simple JAL to a forward label.
    # x1 (ra) should store the address of the instruction after this JAL.
    # t0 will be set to a value after the jump to confirm execution path.
    li      t0,     0xDEADBEEF # Sentinel value
    jal     ra,     target_label_1
    li      t0,     0xCAFEBABE # This instruction should be skipped by the JAL.

target_label_1:
    # If we are here, the JAL was successful.
    # Now test a JAL to a backward label.
    # Store a value in t1 before the jump.
    li      t1,     0x11223344
    jal     t0,     target_label_2 # Store return address in t0 (x5).
return_from_jalr:
    # The jalr from target_label_2 will return here.
    # We jump to the finalization part of the test to avoid an infinite loop.
    j       test_end

target_label_2:
    # If we are here, the second JAL was successful.
    # Now use the return address stored in t0 to jump back.
    # t2 will be set to confirm execution path.
    li      t2,     0x99887766 # Sentinel value
    jalr    zero,   0(t0)      # Jump back to return_from_jalr.
    li      t2,     0xAABBCCDD # This instruction should be skipped by the JALR.

test_end:
    # If we reach here, both JAL and JALR worked correctly.
    # Set t0 to a final value to confirm.
    li      t0,     0x1

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
# The exact value of ra (x1) depends on the linker.
# We verify the control flow by checking the final values of the registers.
GPR05_FINAL_VALUE: .dword 0x1          # t0 (x5) is set to 1 on success.
GPR06_FINAL_VALUE: .dword 0x11223344    # t1 (x6) should retain its value set before the second JAL.
GPR07_FINAL_VALUE: .dword 0x99887766    # t2 (x7) is set inside target_label_2.
