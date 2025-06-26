# Test for the SB (Store Byte) instruction.

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
.section .rodata
.align 3
MEM00_FINAL_VALUE: .byte -8     # Expected value at MEM00_WRITE_VALUE
MEM01_FINAL_VALUE: .byte -7     # Expected value at MEM01_WRITE_VALUE
MEM02_FINAL_VALUE: .byte -6     # etc.
MEM03_FINAL_VALUE: .byte -5
MEM04_FINAL_VALUE: .byte -4
MEM05_FINAL_VALUE: .byte -3
MEM06_FINAL_VALUE: .byte -2
MEM07_FINAL_VALUE: .byte -1
MEM08_FINAL_VALUE: .byte  0
MEM09_FINAL_VALUE: .byte  1
MEM10_FINAL_VALUE: .byte  2
MEM11_FINAL_VALUE: .byte  3
MEM12_FINAL_VALUE: .byte  4
MEM13_FINAL_VALUE: .byte  5
MEM14_FINAL_VALUE: .byte  6
MEM15_FINAL_VALUE: .byte  7

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
        # --- Test Cases for SB ---
        # Load the base address of our test memory region into t0.
        # We use the middle of the region as the base to test both
        # positive and negative offsets.
        la      t0,     MEM08_WRITE_VALUE # t0 = address of MEM08_WRITE_VALUE

        # Store positive values using positive offsets
        li      t1,     0;  sb      t1,     0(t0)   # Store 0 at MEM08
        li      t1,     1;  sb      t1,     1(t0)   # Store 1 at MEM09
        li      t1,     2;  sb      t1,     2(t0)   # Store 2 at MEM10
        li      t1,     3;  sb      t1,     3(t0)   # Store 3 at MEM11
        li      t1,     4;  sb      t1,     4(t0)   # Store 4 at MEM12
        li      t1,     5;  sb      t1,     5(t0)   # Store 5 at MEM13
        li      t1,     6;  sb      t1,     6(t0)   # Store 6 at MEM14
        li      t1,     7;  sb      t1,     7(t0)   # Store 7 at MEM15

        # Store negative values using negative offsets.
        # The sb instruction stores the lowest 8 bits of the source register.
        # For -1 (0xFFFFFFFF), it stores 0xFF.
        li      t1,     -1; sb      t1,     -1(t0)  # Store -1 at MEM07
        li      t1,     -2; sb      t1,     -2(t0)  # Store -2 at MEM06
        li      t1,     -3; sb      t1,     -3(t0)  # Store -3 at MEM05
        li      t1,     -4; sb      t1,     -4(t0)  # Store -4 at MEM04
        li      t1,     -5; sb      t1,     -5(t0)  # Store -5 at MEM03
        li      t1,     -6; sb      t1,     -6(t0)  # Store -6 at MEM02
        li      t1,     -7; sb      t1,     -7(t0)  # Store -7 at MEM01
        li      t1,     -8; sb      t1,     -8(t0)  # Store -8 at MEM00

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
