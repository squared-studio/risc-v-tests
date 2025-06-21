.section .data
.align 3
.global tohost
tohost: .dword 0

.section .data
.align 3
.global fromhost
fromhost: .dword 0

.section .data
.align 3
.global putchar_stdout
putchar_stdout: .dword 0

.section .text
.align 3
.global _start
_start:
    la t0, putchar_stdout
    la a0, hello_string
    la a1, MEM00_WRITE_VALUE

print_loop:
    lb t1, 0(a0)
    sb t1, 0(t0)
    sb t1, 0(a1)
    addi a0, a0, 1
    addi a1, a1, 1
    beqz t1, end_program
    j print_loop

end_program:
    fence
    li a0, 1
    la t0, tohost
    sw a0, 0(t0)
    fence

_forever_loop:
    j _forever_loop

.section .rodata
hello_string: .asciz "Hello World!\n"

.section .rodata
.align 3
MEM00_FINAL_VALUE: .ascii "H"
MEM01_FINAL_VALUE: .ascii "e"
MEM02_FINAL_VALUE: .ascii "l"
MEM03_FINAL_VALUE: .ascii "l"
MEM04_FINAL_VALUE: .ascii "o"
MEM05_FINAL_VALUE: .ascii " "
MEM06_FINAL_VALUE: .ascii "W"
MEM07_FINAL_VALUE: .ascii "o"
MEM08_FINAL_VALUE: .ascii "r"
MEM09_FINAL_VALUE: .ascii "l"
MEM10_FINAL_VALUE: .ascii "d"
MEM11_FINAL_VALUE: .ascii "!"
MEM12_FINAL_VALUE: .ascii "\n"
MEM13_FINAL_VALUE: .byte 0

.section .data
.align 3
MEM00_WRITE_VALUE: .byte 0
MEM01_WRITE_VALUE: .byte 0
MEM02_WRITE_VALUE: .byte 0
MEM03_WRITE_VALUE: .byte 0
MEM04_WRITE_VALUE: .byte 0
MEM05_WRITE_VALUE: .byte 0
MEM06_WRITE_VALUE: .byte 0
MEM07_WRITE_VALUE: .byte 0
MEM08_WRITE_VALUE: .byte 0
MEM09_WRITE_VALUE: .byte 0
MEM10_WRITE_VALUE: .byte 0
MEM11_WRITE_VALUE: .byte 0
MEM12_WRITE_VALUE: .byte 0
MEM13_WRITE_VALUE: .byte 0
