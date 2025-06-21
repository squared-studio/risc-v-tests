.section .data
.align 3
.global tohost
tohost: .dword 0

.section .data
.align 3
.global fromhost
fromhost: .dword 0

.section .text
.align 3
.global _start
_start:
    addi zero,  zero,   1
    addi   t1,  zero,  -1
    addi   t2,    t1,   2
    addi   t3,  zero,   132
    addi   t4,  zero,  -133
    addi   t5,    t4,   134
    addi   t6,  zero,   1232

    fence
    addi   a0,  zero,   1
    la t0, tohost
    sw a0, 0(t0)
    fence

_forever_loop:
    j _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR06_FINAL_VALUE: .dword -1
GPR07_FINAL_VALUE: .dword 1
GPR28_FINAL_VALUE: .dword 132
GPR29_FINAL_VALUE: .dword -133
GPR30_FINAL_VALUE: .dword 1
GPR31_FINAL_VALUE: .dword 1232
