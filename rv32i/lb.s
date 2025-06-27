# Test for the LB (Load Byte) instruction.

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

# .data section: Memory region to be loaded from.
# Initialize with known byte values.
.section .data
.align 1 # Align to byte boundary
MEM_TEST_REGION:
    .byte 0x12          # Byte 0 (offset 0)
    .byte 0xFE          # Byte 1 (offset 1) = -2 (as signed)
    .byte 0x00          # Byte 2 (offset 2) = 0
    .byte 0x7F          # Byte 3 (offset 3) = Max positive signed byte
    .byte 0x80          # Byte 4 (offset 4) = Min negative signed byte
    .byte 0xCD          # Byte 5 (offset 5)
    .byte 0xAB          # Byte 6 (offset 6)
    .byte 0xEF          # Byte 7 (offset 7)

.section .text
.align 3
.global _start
_start:
    # --- Test Cases for LB ---
    # LB loads an 8-bit byte from memory: rd = mem[rs1 + imm]
    # The loaded byte is sign-extended to XLEN (32-bit for RV32).

    # Load the base address of our test memory region into t0.
    la      t0,     MEM_TEST_REGION

    # Test case 1: Load byte from offset 0 (positive value)
    # t1 = MEM_TEST_REGION[0] = 0x12
    lb      t1,     0(t0)

    # Test case 2: Load byte from offset 1 (negative value)
    # t2 = MEM_TEST_REGION[1] = 0xFE (-2)
    lb      t2,     1(t0)

    # Test case 3: Load byte from offset 2 (zero value)
    # t3 = MEM_TEST_REGION[2] = 0x00 (0)
    lb      t3,     2(t0)

    # Test case 4: Load byte from offset 3 (max positive signed)
    # t4 = MEM_TEST_REGION[3] = 0x7F
    lb      t4,     3(t0)

    # Test case 5: Load byte from offset 4 (min negative signed)
    # t5 = MEM_TEST_REGION[4] = 0x80
    lb      t5,     4(t0)

    # Test case 6: Load byte from offset 5
    # t6 = MEM_TEST_REGION[5] = 0xCD
    lb      t6,     5(t0)

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
GPR06_FINAL_VALUE: .dword 0x00000012    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0xFFFFFFFE    # t2 (x7)
GPR28_FINAL_VALUE: .dword 0x00000000    # t3 (x28)
GPR29_FINAL_VALUE: .dword 0x0000007F    # t4 (x29)
GPR30_FINAL_VALUE: .dword 0xFFFFFF80    # t5 (x30)
GPR31_FINAL_VALUE: .dword 0xFFFFFFCD    # t6 (x31)
