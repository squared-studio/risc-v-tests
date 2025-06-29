# Test for the LHU (Load Halfword Unsigned) instruction.

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

# .data section: Memory region to be loaded from.
# Initialize with known halfword values.
.section .data
.align 1 # Align to byte boundary for specific offsets
MEM_TEST_REGION:
    .half 0x1234        # Halfword 0 (offset 0)
    .half 0xFFFE        # Halfword 1 (offset 2) = -2 (as signed)
    .half 0x0000        # Halfword 2 (offset 4) = 0
    .half 0x7FFF        # Halfword 3 (offset 6) = Max positive signed halfword
    .half 0x8000        # Halfword 4 (offset 8) = Min negative signed halfword (as signed)
    .half 0xABCD        # Halfword 5 (offset 10)

.section .text
.align 3
.global _start
_start:
    # --- Test Cases for LHU ---
    # LHU loads a 16-bit halfword from memory: rd = mem[rs1 + imm]
    # The loaded halfword is zero-extended to XLEN (32-bit for RV32).

    # Load the base address of our test memory region into t0.
    la      t0,     MEM_TEST_REGION

    # Test case 1: Load halfword from offset 0 (positive value)
    # t1 = MEM_TEST_REGION[0] = 0x1234
    lhu     t1,     0(t0)

    # Test case 2: Load halfword from offset 2 (value 0xFFFE, treated as unsigned)
    # t2 = MEM_TEST_REGION[2] = 0x0000FFFE
    lhu     t2,     2(t0)

    # Test case 3: Load halfword from offset 4 (zero value)
    # t3 = MEM_TEST_REGION[4] = 0x0000 (0)
    lhu     t3,     4(t0)

    # Test case 4: Load halfword from offset 6 (max positive signed, also positive unsigned)
    # t4 = MEM_TEST_REGION[6] = 0x7FFF
    lhu     t4,     6(t0)

    # Test case 5: Load halfword from offset 8 (value 0x8000, treated as unsigned)
    # t5 = MEM_TEST_REGION[8] = 0x00008000
    lhu     t5,     8(t0)

    # Test case 6: Load halfword from offset 10
    # t6 = MEM_TEST_REGION[10] = 0x0000ABCD
    lhu     t6,     10(t0)

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
GPR06_FINAL_VALUE: .dword 0x00001234    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x0000FFFE    # t2 (x7)
GPR28_FINAL_VALUE: .dword 0x00000000    # t3 (x28)
GPR29_FINAL_VALUE: .dword 0x00007FFF    # t4 (x29)
GPR30_FINAL_VALUE: .dword 0x00008000    # t5 (x30)
GPR31_FINAL_VALUE: .dword 0x0000ABCD    # t6 (x31)
