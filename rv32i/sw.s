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
MEM00_FINAL_VALUE: .byte -2
MEM01_FINAL_VALUE: .byte -1
MEM02_FINAL_VALUE: .byte -1
MEM03_FINAL_VALUE: .byte -1
MEM04_FINAL_VALUE: .byte -1
MEM05_FINAL_VALUE: .byte -1
MEM06_FINAL_VALUE: .byte -1
MEM07_FINAL_VALUE: .byte -1
MEM08_FINAL_VALUE: .byte  0
MEM09_FINAL_VALUE: .byte  0
MEM10_FINAL_VALUE: .byte  0
MEM11_FINAL_VALUE: .byte  0
MEM12_FINAL_VALUE: .byte  1
MEM13_FINAL_VALUE: .byte  0
MEM14_FINAL_VALUE: .byte  0
MEM15_FINAL_VALUE: .byte  0

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
    sw t1,  0(t0)

    li t1,  1
    sw t1,  4(t0)

    li t1, -1
    sw t1, -4(t0)

    li t1, -2
    sw t1, -8(t0)

    fence
    li a0, 1
    la t0, tohost
    sw a0, 0(t0)
    fence

_forever_loop:
    j _forever_loop
