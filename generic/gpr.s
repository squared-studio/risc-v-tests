# Test for General Purpose Registers (GPRs).
# It verifies that all 32 GPRs can be written to and hold their values.
# It populates each register xN with the value -N (except for x0).

.section .rodata
.align 3
# Expected final values for all 32 GPRs.
# The test framework will compare the final state of the registers
# against these values to determine pass/fail.
GPR00_FINAL_VALUE: .dword  0     # x0 (zero) is hardwired to 0.
GPR01_FINAL_VALUE: .dword -1     # x1 (ra)
GPR02_FINAL_VALUE: .dword -2     # x2 (sp)
GPR03_FINAL_VALUE: .dword -3     # x3 (gp)
GPR04_FINAL_VALUE: .dword -4     # x4 (tp)
GPR05_FINAL_VALUE: .dword -5     # x5 (t0)
GPR06_FINAL_VALUE: .dword -6     # x6 (t1)
GPR07_FINAL_VALUE: .dword -7     # x7 (t2)
GPR08_FINAL_VALUE: .dword -8     # x8 (s0/fp)
GPR09_FINAL_VALUE: .dword -9     # x9 (s1)
GPR10_FINAL_VALUE: .dword -10    # x10 (a0)
GPR11_FINAL_VALUE: .dword -11    # x11 (a1)
GPR12_FINAL_VALUE: .dword -12    # x12 (a2)
GPR13_FINAL_VALUE: .dword -13    # x13 (a3)
GPR14_FINAL_VALUE: .dword -14    # x14 (a4)
GPR15_FINAL_VALUE: .dword -15    # x15 (a5)
GPR16_FINAL_VALUE: .dword -16    # x16 (a6)
GPR17_FINAL_VALUE: .dword -17    # x17 (a7)
GPR18_FINAL_VALUE: .dword -18    # x18 (s2)
GPR19_FINAL_VALUE: .dword -19    # x19 (s3)
GPR20_FINAL_VALUE: .dword -20    # x20 (s4)
GPR21_FINAL_VALUE: .dword -21    # x21 (s5)
GPR22_FINAL_VALUE: .dword -22    # x22 (s6)
GPR23_FINAL_VALUE: .dword -23    # x23 (s7)
GPR24_FINAL_VALUE: .dword -24    # x24 (s8)
GPR25_FINAL_VALUE: .dword -25    # x25 (s9)
GPR26_FINAL_VALUE: .dword -26    # x26 (s10)
GPR27_FINAL_VALUE: .dword -27    # x27 (s11)
GPR28_FINAL_VALUE: .dword -28    # x28 (t3)
GPR29_FINAL_VALUE: .dword -29    # x29 (t4)
GPR30_FINAL_VALUE: .dword -30    # x30 (t5)
GPR31_FINAL_VALUE: .dword -31    # x31 (t6)

.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

.align 3
.section .text
.global _start
_start:
    # --- Test Cases for GPRs ---
    # Create a dependency chain to load -N into each register xN.
    addi  x0,  x0, -1   # Attempt to write to x0; should have no effect. x0 remains 0.
    addi  x1,  x0, -1   # x1 = 0 + (-1) = -1
    addi  x2,  x1, -1   # x2 = -1 + (-1) = -2
    addi  x3,  x2, -1   # x3 = -2 + (-1) = -3
    addi  x4,  x3, -1   # ... and so on for all registers.
    addi  x5,  x4, -1
    addi  x6,  x5, -1
    addi  x7,  x6, -1
    addi  x8,  x7, -1
    addi  x9,  x8, -1
    addi x10,  x9, -1
    addi x11, x10, -1
    addi x12, x11, -1
    addi x13, x12, -1
    addi x14, x13, -1
    addi x15, x14, -1
    addi x16, x15, -1
    addi x17, x16, -1
    addi x18, x17, -1
    addi x19, x18, -1
    addi x20, x19, -1
    addi x21, x20, -1
    addi x22, x21, -1
    addi x23, x22, -1
    addi x24, x23, -1
    addi x25, x24, -1
    addi x26, x25, -1
    addi x27, x26, -1
    addi x28, x27, -1
    addi x29, x28, -1   # x29 = -28 + (-1) = -29

    # --- Test Completion ---
    # Signal success to the host. Note that x30 and x31 are used here
    # and then immediately overwritten with their final test values.
    fence
    li   x30, 3         # Use x30 to hold the success code (1).
    la   x31, tohost    # Use x31 to hold the tohost address.
    sw   x30, 0(x31)    # Write success code to tohost.

    # Set the final values for x30 and x31.
    addi x30, x29, -1   # x30 = -29 + (-1) = -30. This overwrites the '1'.
    addi x31, x30, -1   # x31 = -30 + (-1) = -31. This overwrites the tohost address.
    fence

loop:                   # Infinite loop to halt the processor.
    j    loop
