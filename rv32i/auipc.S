# Test for the AUIPC (Add Upper Immediate to PC) instruction.
# It verifies PC-relative addressing.

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
        # Test case 1: Basic AUIPC functionality.
        # auipc forms a 32-bit offset from the 20-bit U-immediate,
        # shifting it left by 12 bits and adding it to the PC.
        # Here, t0 = PC + (1 << 12).
        auipc   t0,     1           # t0 = PC + 0x1000

        # Test case 2: PC-relative load.
        # Use auipc to get the current PC, then add an offset to load data.
        # 1. Get the address of the current instruction into t1.
        auipc   t1,     0           # t1 = PC of this instruction

        # 2. Calculate the address of 'data_to_load'.
        # The offset is 16 bytes (4 instructions * 4 bytes/instruction) from
        # the 'auipc t1, 0' instruction to 'data_to_load'.
        addi    t2,     t1,     16  # t2 = PC + 16, which is the address of data_to_load

        # 3. Load the word from the calculated address into t3.
        lw      t3,     0(t2)       # t3 should now hold 0xFEEDF00D

        # Skip over the data word to continue execution.
        j       continue_execution

data_to_load:
        .word   0xFEEDF00D          # The data to be loaded using PC-relative addressing.

continue_execution:
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
GPR00_FINAL_VALUE: .dword 0                     # x0 (zero) should always be 0.
GPR28_FINAL_VALUE: .dword 0xFFFFFFFFFEEDF00D    # t3 (x28) should hold the loaded data, sign-extended.
