# Test for the XOR (Exclusive OR) instruction.

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
    # --- Test Cases for XOR ---
    # XOR performs bitwise exclusive OR: rd = rs1 ^ rs2

    # Test case 1: Simple XOR
    # t0 = 0b1010 ^ 0b0110 = 0b1100 (10 ^ 6 = 12)
    li      a0,     10      # 0xA
    li      a1,     6       # 0x6
    xor     t0,     a0,     a1

    # Test case 2: XOR with zero
    # t1 = 0xABCD ^ 0 = 0xABCD
    li      a0,     0xABCD
    li      a1,     0
    xor     t1,     a0,     a1

    # Test case 3: XOR with all ones (-1)
    # t2 = 0x12345678 ^ 0xFFFFFFFF = 0xEDCBA987 (bitwise NOT)
    li      a0,     0x12345678
    li      a1,     -1
    xor     t2,     a0,     a1

    # Test case 4: XOR identical values (should be zero)
    # t3 = 0x5555 ^ 0x5555 = 0
    li      a0,     0x5555
    li      a1,     0x5555
    xor     t3,     a0,     a1

    # Test case 5: XOR with negative numbers
    # t4 = -10 ^ -5
    # -10 = 0xFFFFFFF6
    # -5  = 0xFFFFFFFB
    # XOR = 0x0000000D (13)
    li      a0,     -10
    li      a1,     -5
    xor     t4,     a0,     a1

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
GPR05_FINAL_VALUE: .dword 12        # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0xEDCBA987 # t2 (x7)
GPR28_FINAL_VALUE: .dword 0         # t3 (x28)
GPR29_FINAL_VALUE: .dword 13        # t4 (x29)
