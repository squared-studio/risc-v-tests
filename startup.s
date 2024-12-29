.section .boot
.globl _start
_start:
    call main
    la t0, tohost
    sw zero, 0(t0)
_foreverloop:
    j _foreverloop
