# Test for the LW (Load Word) instruction.

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

# .data section: Memory region to be loaded from.
# Initialize with known word values.
.section .data
.align 2 # Align to 4-byte boundary for words
MEM_TEST_REGION:
    .word 0x12345678    # Word 0 (offset 0)
    .word 0xFFFFFFFF    # Word 1 (offset 4) = -1
    .word 0x00000000    # Word 2 (offset 8) = 0
    .word 0xABCDEF01    # Word 3 (offset 12)

.section .text
.align 3
.global _start
_start:
    # --- Test Cases for LW ---
    # LW loads a 32-bit word from memory: rd = mem[rs1 + imm]
    # The loaded word is sign-extended to XLEN (64-bit for RV64).

    # Load the base address of our test memory region into t0.
    la      t0,     MEM_TEST_REGION

    # Test case 1: Load word from offset 0
    # t1 = MEM_TEST_REGION[0] = 0x12345678
    lw      t1,     0(t0)

    # Test case 2: Load word from offset 4 (negative value)
    # t2 = MEM_TEST_REGION[4] = 0xFFFFFFFF (-1)
    lw      t2,     4(t0)

    # Test case 3: Load word from offset 8 (zero value)
    # t3 = MEM_TEST_REGION[8] = 0x00000000 (0)
    lw      t3,     8(t0)

    # Test case 4: Load word from offset 12
    # t4 = MEM_TEST_REGION[12] = 0xABCDEF01
    lw      t4,     12(t0)

    # --- Test Completion ---
    fence
    li      a0,     1
    la      t0,     tohost
    sw      a0,     0(t0)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR06_FINAL_VALUE: .dword 0x0000000012345678 # t1 (x6) - sign-extended
GPR07_FINAL_VALUE: .dword 0xFFFFFFFFFFFFFFFF # t2 (x7) - sign-extended
GPR28_FINAL_VALUE: .dword 0x0000000000000000 # t3 (x28) - sign-extended
GPR29_FINAL_VALUE: .dword 0xFFFFFFFFABCDEF01 # t4 (x29) - sign-extended
