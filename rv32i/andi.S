# Test for the ANDI (AND Immediate) instruction.

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
    # --- Test Cases for ANDI ---
    # ANDI performs bitwise AND with a sign-extended immediate: rd = rs1 & imm

    # Test case 1: Simple ANDI
    # t0 = 0b1111 & 0b1010 = 0b1010 (15 & 10 = 10)
    li      a0,     15      # 0xF
    andi    t0,     a0,     10      # 0xA

    # Test case 2: ANDI with zero immediate
    # t1 = 0xABCD & 0 = 0
    li      a0,     0xABCD
    andi    t1,     a0,     0

    # Test case 3: ANDI with all ones immediate (-1)
    # This should be a no-op as the immediate is sign-extended to all 1s.
    # t2 = 0x12345678 & 0xFFFFFFFF = 0x12345678
    li      a0,     0x12345678
    andi    t2,     a0,     -1

    # Test case 4: ANDI to mask lower bits
    # t3 = 0xABCDEF & 0xFFF = 0xDEF
    li      a0,     0xABCDEF
    andi    t3,     a0,     -1

    # Test case 5: ANDI with negative rs1
    # t4 = -10 & 0x0F
    # -10 = 0xFFFFFFF6
    # 0x0F = 0x0000000F
    # AND = 0x00000006 (6)
    li      a0,     -10
    andi    t4,     a0,     0x0F

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
GPR05_FINAL_VALUE: .dword 10         # t0 (x5)
GPR06_FINAL_VALUE: .dword 0          # t1 (x6)
GPR07_FINAL_VALUE: .dword 0x12345678 # t2 (x7)
GPR28_FINAL_VALUE: .dword 0x0ABCDEF  # t3 (x28)
GPR29_FINAL_VALUE: .dword 6          # t4 (x29)
