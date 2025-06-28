# Test for the XORI (Exclusive OR Immediate) instruction.

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
    # --- Test Cases for XORI ---
    # XORI performs bitwise XOR with a sign-extended immediate: rd = rs1 ^ imm

    # Test case 1: Simple XORI
    # t0 = 0b1010 ^ 0b0110 = 0b1100 (10 ^ 6 = 12)
    li      a0,     10      # 0xA
    xori    t0,     a0,     6       # 0x6

    # Test case 2: XORI with zero immediate
    # t1 = 0xABCD ^ 0 = 0xABCD
    li      a0,     0xABCD
    xori    t1,     a0,     0

    # Test case 3: XORI with all ones immediate (-1)
    # This performs a bitwise NOT on the lower 12 bits.
    # t2 = 0x12345678 ^ 0xFFFFFFFF = 0xEDCBA987
    li      a0,     0x12345678
    xori    t2,     a0,     -1      # Immediate is sign-extended to all 1s

    # Test case 4: XORI with negative rs1
    # t3 = -10 ^ 0x0F
    # -10 = 0xFFFFFFF6
    # 0x0F = 0x0000000F
    # XOR = 0xFFFFFFF9 (-7)
    li      a0,     -10
    xori    t3,     a0,     0x0F

    # Test case 5: XORI to flip specific bits
    # t4 = 0xAAAA ^ 0x555 = 0xAFFF
    li      a0,     0xAAAA
    xori    t4,     a0,     0x555

    # --- Test Completion ---
    fence
    li      a0,     1
    la      a1,     tohost
    sw      a0,     0(a1)
    fence

_forever_loop:
    j       _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 12        # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0xFFFFFFFFEDCBA987 # t2 (x7)
GPR28_FINAL_VALUE: .dword -7        # t3 (x28)
GPR29_FINAL_VALUE: .dword 0xAFFF     # t4 (x29)
