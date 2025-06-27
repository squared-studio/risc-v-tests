# Test for the ORI (Bitwise OR Immediate) instruction.

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
    # --- Test Cases for ORI ---
    # ORI performs bitwise OR with immediate: rd = rs1 | imm

    # Test case 1: Simple ORI
    # t0 = 0b1010 | 0b0110 = 0b1110 (10 | 6 = 14)
    li      a0,     10      # 0xA
    ori     t0,     a0,     6       # 0x6

    # Test case 2: ORI with zero immediate
    # t1 = 0xABCD | 0 = 0xABCD
    li      a0,     0xABCD
    ori     t1,     a0,     0

    # Test case 3: ORI with all ones immediate (-1)
    # t2 = 0x12345678 | 0xFFF = 0x12345FFF (immediate is sign-extended)
    li      a0,     0x12345678
    ori     t2,     a0,     -1      # -1 (0xFFF) immediate becomes 0xFFFFFFFF

    # Test case 4: ORI with negative rs1
    # t3 = -10 | 0x0F
    # -10 = 0xFFFFFFF6
    # 0x0F = 0x0000000F
    # OR  = 0xFFFFFFFF (-1)
    li      a0,     -10
    ori     t3,     a0,     0x0F

    # Test case 5: ORI with immediate that clears bits (not possible with OR, but for completeness)
    # t4 = 0xAAAA | 0x5555 = 0xFFFF
    li      a0,     0xAAAA
    ori     t4,     a0,     0x555   # 0x555 is 0b010101010101
                                    # 0xAAAA is 0b1010101010101010
                                    # Result: 0xAFBF (0b1010111110111111)

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
GPR05_FINAL_VALUE: .dword 14        # t0 (x5)
GPR06_FINAL_VALUE: .dword 0xABCD    # t1 (x6)
GPR07_FINAL_VALUE: .dword 0xFFFFFFFF # t2 (x7)
GPR28_FINAL_VALUE: .dword 0xFFFFFFFF # t3 (x28)
GPR29_FINAL_VALUE: .dword 0xAFBF    # t4 (x29)
