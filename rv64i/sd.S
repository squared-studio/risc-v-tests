# Test for the SD (Store Doubleword) instruction (RV64I).
# This test verifies that 64-bit values are correctly stored to memory.

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

# .rodata section: Expected final memory values.
# The test framework will compare the memory region written by the test
# against these values to determine pass/fail.
# Note: RISC-V is little-endian. A 64-bit doubleword is stored with the
# least significant byte at the lowest address.
.section .rodata
.align 3
# Expected values for the 16-byte test region.
# For sd t1, addr: memory[addr+7]..memory[addr] = t1[63:0]
#
# Store -1 (0xFFFFFFFFFFFFFFFF) at MEM00 (offset -8 from t0):
# MEM00..07 = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}
MEM00_FINAL_VALUE: .byte -1     # 0xFF
MEM01_FINAL_VALUE: .byte -1     # 0xFF
MEM02_FINAL_VALUE: .byte -1     # 0xFF
MEM03_FINAL_VALUE: .byte -1     # 0xFF
MEM04_FINAL_VALUE: .byte -1     # 0xFF
MEM05_FINAL_VALUE: .byte -1     # 0xFF
MEM06_FINAL_VALUE: .byte -1     # 0xFF
MEM07_FINAL_VALUE: .byte -1     # 0xFF
#
# Store 0 (0x0000000000000000) at MEM08 (offset 0 from t0):
# MEM08..15 = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
MEM08_FINAL_VALUE: .byte  0     # 0x00
MEM09_FINAL_VALUE: .byte  0     # 0x00
MEM10_FINAL_VALUE: .byte  0     # 0x00
MEM11_FINAL_VALUE: .byte  0     # 0x00
MEM12_FINAL_VALUE: .byte  0     # 0x00
MEM13_FINAL_VALUE: .byte  0     # 0x00
MEM14_FINAL_VALUE: .byte  0     # 0x00
MEM15_FINAL_VALUE: .byte  0     # 0x00

.section .data
.section .data
.align 3
# The memory region to be written to.
# It is pre-initialized with a known pattern (0xAA) to ensure that
# the test is actually writing the correct values.
MEM00_WRITE_VALUE: .byte 0xAA   # Start of the 16-byte test memory region.
MEM01_WRITE_VALUE: .byte 0xAA   # This will be overwritten by the test.
MEM02_WRITE_VALUE: .byte 0xAA
MEM03_WRITE_VALUE: .byte 0xAA
MEM04_WRITE_VALUE: .byte 0xAA
MEM05_WRITE_VALUE: .byte 0xAA
MEM06_WRITE_VALUE: .byte 0xAA
MEM07_WRITE_VALUE: .byte 0xAA
MEM08_WRITE_VALUE: .byte 0xAA   # The base address for the test will point here.
MEM09_WRITE_VALUE: .byte 0xAA
MEM10_WRITE_VALUE: .byte 0xAA
MEM11_WRITE_VALUE: .byte 0xAA
MEM12_WRITE_VALUE: .byte 0xAA
MEM13_WRITE_VALUE: .byte 0xAA
MEM14_WRITE_VALUE: .byte 0xAA
MEM15_WRITE_VALUE: .byte 0xAA

.section .text
.global _start
_start:
        # --- Test Cases for SD ---
        # Load the base address of our test memory region into t0.
        # We use the middle of the region as the base to test both
        # positive and negative offsets.
        la      t0,     MEM08_WRITE_VALUE # t0 = address of MEM08_WRITE_VALUE

        # Store 0 (0x0000000000000000) at MEM08.
        li      t1,     0;      sd      t1,     0(t0)

        # Store -1 (0xFFFFFFFFFFFFFFFF) at MEM00.
        li      t1,     -1;     sd      t1,     -8(t0)

        # --- Test Completion ---
        # Signal success to the host environment.
        fence
        li      a0,     1           # Use 1 to indicate success.
        la      t0,     tohost      # Load address of tohost.
        sw      a0,     0(t0)       # Write success code to tohost.
        fence

_forever_loop:
        # Infinite loop to halt the processor after the test is done.
        j       _forever_loop
