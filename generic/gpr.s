.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword  0
GPR01_FINAL_VALUE: .dword -1
GPR02_FINAL_VALUE: .dword -2
GPR03_FINAL_VALUE: .dword -3
GPR04_FINAL_VALUE: .dword -4
GPR05_FINAL_VALUE: .dword -5
GPR06_FINAL_VALUE: .dword -6
GPR07_FINAL_VALUE: .dword -7
GPR08_FINAL_VALUE: .dword -8
GPR09_FINAL_VALUE: .dword -9
GPR10_FINAL_VALUE: .dword -10
GPR11_FINAL_VALUE: .dword -11
GPR12_FINAL_VALUE: .dword -12
GPR13_FINAL_VALUE: .dword -13
GPR14_FINAL_VALUE: .dword -14
GPR15_FINAL_VALUE: .dword -15
GPR16_FINAL_VALUE: .dword -16
GPR17_FINAL_VALUE: .dword -17
GPR18_FINAL_VALUE: .dword -18
GPR19_FINAL_VALUE: .dword -19
GPR20_FINAL_VALUE: .dword -20
GPR21_FINAL_VALUE: .dword -21
GPR22_FINAL_VALUE: .dword -22
GPR23_FINAL_VALUE: .dword -23
GPR24_FINAL_VALUE: .dword -24
GPR25_FINAL_VALUE: .dword -25
GPR26_FINAL_VALUE: .dword -26
GPR27_FINAL_VALUE: .dword -27
GPR28_FINAL_VALUE: .dword -28
GPR29_FINAL_VALUE: .dword -29
GPR30_FINAL_VALUE: .dword -30
GPR31_FINAL_VALUE: .dword -31

.section .data
.align 3
.global tohost
tohost: .dword 0

.section .data
.align 3
.global fromhost
fromhost: .dword 0

.align 3
.section .text
.global _start
_start:
    addi  x0,  x0, -1
    addi  x1,  x0, -1
    addi  x2,  x1, -1
    addi  x3,  x2, -1
    addi  x4,  x3, -1
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
    addi x29, x28, -1

    fence
    li x30, 1
    la x31, tohost
    sw x30, 0(x31)
    addi x30, x29, -1
    addi x31, x30, -1
    fence


loop:
    j loop
