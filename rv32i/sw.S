# Test for the SW (Store Word) instruction.

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
# Note: RISC-V is little-endian, so a word is stored with the
# least significant byte at the lower address.
.section .rodata
.align 3
# Expected values for the 16-byte test region.
# For sw t1, addr: memory[addr+3]..memory[addr] = t1[31:0]
# -8(t0) -> MEM00: sw -2 (0xFFFFFFFE) -> MEM00..03 = {0xFE, 0xFF, 0xFF, 0xFF}
# -4(t0) -> MEM04: sw -1 (0xFFFFFFFF) -> MEM04..07 = {0xFF, 0xFF, 0xFF, 0xFF}
#  0(t0) -> MEM08: sw  0 (0x00000000) -> MEM08..11 = {0x00, 0x00, 0x00, 0x00}
#  4(t0) -> MEM12: sw  1 (0x00000001) -> MEM12..15 = {0x01, 0x00, 0x00, 0x00}
MEM00_FINAL_VALUE: .byte -2     # 0xFE
MEM01_FINAL_VALUE: .byte -1     # 0xFF
MEM02_FINAL_VALUE: .byte -1     # 0xFF
MEM03_FINAL_VALUE: .byte -1     # 0xFF
MEM04_FINAL_VALUE: .byte -1     # 0xFF
MEM05_FINAL_VALUE: .byte -1     # 0xFF
MEM06_FINAL_VALUE: .byte -1     # 0xFF
MEM07_FINAL_VALUE: .byte -1     # 0xFF
MEM08_FINAL_VALUE: .byte  0     # 0x00
MEM09_FINAL_VALUE: .byte  0     # 0x00
MEM10_FINAL_VALUE: .byte  0     # 0x00
MEM11_FINAL_VALUE: .byte  0     # 0x00
MEM12_FINAL_VALUE: .byte  1     # 0x01
MEM13_FINAL_VALUE: .byte  0     # 0x00
MEM14_FINAL_VALUE: .byte  0     # 0x00
MEM15_FINAL_VALUE: .byte  0     # 0x00

# .data section: The memory region to be written to.
# It is pre-initialized with a known pattern (0xAA) to ensure that
# the test is actually writing the correct values.
.section .data
.align 3
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
        # --- Test Cases for SW ---
        # Load the base address of our test memory region into t0.
        # We use the middle of the region as the base to test both
        # positive and negative offsets.
        la      t0,     MEM08_WRITE_VALUE # t0 = address of MEM08_WRITE_VALUE

        # Store various word values to aligned addresses.
        li      t1,     0;      sw      t1,     0(t0)   # Store 0 at MEM08
        li      t1,     1;      sw      t1,     4(t0)   # Store 1 at MEM12
        li      t1,     -1;     sw      t1,     -4(t0)  # Store -1 at MEM04
        li      t1,     -2;     sw      t1,     -8(t0)  # Store -2 at MEM00

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
