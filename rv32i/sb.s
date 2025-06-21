.section .data
.align 3
.global tohost
tohost: .dword 0

.section .data
.align 3
.global fromhost
fromhost: .dword 0

.section .rodata
.align 3
MEM00_FINAL_VALUE: .byte -8
MEM01_FINAL_VALUE: .byte -7
MEM02_FINAL_VALUE: .byte -6
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

.section .data
.align 3
MEM00_WRITE_VALUE: .byte 0xAA
MEM01_WRITE_VALUE: .byte 0xAA
MEM02_WRITE_VALUE: .byte 0xAA
MEM03_WRITE_VALUE: .byte 0xAA
MEM04_WRITE_VALUE: .byte 0xAA
MEM05_WRITE_VALUE: .byte 0xAA
MEM06_WRITE_VALUE: .byte 0xAA
MEM07_WRITE_VALUE: .byte 0xAA
MEM08_WRITE_VALUE: .byte 0xAA
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
    la t0, MEM08_WRITE_VALUE

    li t1,  0
    sb t1,  0(t0)

    li t1,  1
    sb t1,  1(t0)

    li t1,  2
    sb t1,  2(t0)

    li t1,  3
    sb t1,  3(t0)

    li t1,  4
    sb t1,  4(t0)

    li t1,  5
    sb t1,  5(t0)

    li t1,  6
    sb t1,  6(t0)

    li t1,  7
    sb t1,  7(t0)

    li t1, -1
    sb t1, -1(t0)

    li t1, -2
    sb t1, -2(t0)

    li t1, -3
    sb t1, -3(t0)

    li t1, -4
    sb t1, -4(t0)

    li t1, -5
    sb t1, -5(t0)

    li t1, -6
    sb t1, -6(t0)

    li t1, -7
    sb t1, -7(t0)

    li t1, -8
    sb t1, -8(t0)

    fence
    li a0, 1
    la t0, tohost
    sw a0, 0(t0)
    fence

_forever_loop:
    j _forever_loop
