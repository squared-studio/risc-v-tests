# Test for the SH (Store Half-word) instruction.

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
# Note: RISC-V is little-endian, so a half-word is stored with the
# least significant byte at the lower address.
.section .rodata
.align 3
# Expected values for the 16-byte test region.
# For sh t1, addr: memory[addr+1]:memory[addr] = t1[15:0]
# -8(t0) -> MEM00: sh -4 (0xFFFC) -> MEM00=0xFC(-4), MEM01=0xFF(-1)
# -6(t0) -> MEM02: sh -3 (0xFFFD) -> MEM02=0xFD(-3), MEM03=0xFF(-1)
# -4(t0) -> MEM04: sh -2 (0xFFFE) -> MEM04=0xFE(-2), MEM05=0xFF(-1)
# -2(t0) -> MEM06: sh -1 (0xFFFF) -> MEM06=0xFF(-1), MEM07=0xFF(-1)
#  0(t0) -> MEM08: sh  0 (0x0000) -> MEM08=0x00(0),  MEM09=0x00(0)
#  2(t0) -> MEM10: sh  1 (0x0001) -> MEM10=0x01(1),  MEM11=0x00(0)
#  4(t0) -> MEM12: sh  2 (0x0002) -> MEM12=0x02(2),  MEM13=0x00(0)
#  6(t0) -> MEM14: sh  3 (0x0003) -> MEM14=0x03(3),  MEM15=0x00(0)
MEM00_FINAL_VALUE: .byte -4     # 0xFC
MEM01_FINAL_VALUE: .byte -1     # 0xFF
MEM02_FINAL_VALUE: .byte -3     # 0xFD
MEM03_FINAL_VALUE: .byte -1     # 0xFF
MEM04_FINAL_VALUE: .byte -2     # 0xFE
MEM05_FINAL_VALUE: .byte -1     # 0xFF
MEM06_FINAL_VALUE: .byte -1     # 0xFF
MEM07_FINAL_VALUE: .byte -1     # 0xFF
MEM08_FINAL_VALUE: .byte  0     # 0x00
MEM09_FINAL_VALUE: .byte  0     # 0x00
MEM10_FINAL_VALUE: .byte  1     # 0x01
MEM11_FINAL_VALUE: .byte  0     # 0x00
MEM12_FINAL_VALUE: .byte  2     # 0x02
MEM13_FINAL_VALUE: .byte  0     # 0x00
MEM14_FINAL_VALUE: .byte  3     # 0x03
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
        # --- Test Cases for SH ---
        # Load the base address of our test memory region into t0.
        # We use the middle of the region as the base to test both
        # positive and negative offsets.
        la      t0,     MEM08_WRITE_VALUE # t0 = address of MEM08_WRITE_VALUE

        # Store positive values using positive, aligned offsets.
        li      t1,     0;      sh      t1,     0(t0)   # Store 0 at MEM08
        li      t1,     1;      sh      t1,     2(t0)   # Store 1 at MEM10
        li      t1,     2;      sh      t1,     4(t0)   # Store 2 at MEM12
        li      t1,     3;      sh      t1,     6(t0)   # Store 3 at MEM14

        # Store negative values using negative, aligned offsets.
        # The sh instruction stores the lowest 16 bits of the source register.
        li      t1,     -1;     sh      t1,     -2(t0)  # Store -1 (0xFFFF) at MEM06
        li      t1,     -2;     sh      t1,     -4(t0)  # Store -2 (0xFFFE) at MEM04
        li      t1,     -3;     sh      t1,     -6(t0)  # Store -3 (0xFFFD) at MEM02
        li      t1,     -4;     sh      t1,     -8(t0)  # Store -4 (0xFFFC) at MEM00

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
