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
    call main

.section .text
.align 3
_exit:
    fence
    slli a0, a0, 1
    ori  a0, a0, 1
    la t0, tohost
    sw a0, 0(t0)
    fence

.section .text
.align 3
_forever_loop:
    j _forever_loop

.section .rodata
.align 3
GPR00_FINAL_VALUE: .dword 0
GPR01_FINAL_VALUE: .dword 0
GPR02_FINAL_VALUE: .dword 0
GPR03_FINAL_VALUE: .dword 0
GPR04_FINAL_VALUE: .dword 0
GPR05_FINAL_VALUE: .dword 0
GPR06_FINAL_VALUE: .dword 0
GPR07_FINAL_VALUE: .dword 0
GPR08_FINAL_VALUE: .dword 0
GPR09_FINAL_VALUE: .dword 0
GPR10_FINAL_VALUE: .dword 0
GPR11_FINAL_VALUE: .dword 0
GPR12_FINAL_VALUE: .dword 0
GPR13_FINAL_VALUE: .dword 0
GPR14_FINAL_VALUE: .dword 0
GPR15_FINAL_VALUE: .dword 0
GPR16_FINAL_VALUE: .dword 0
GPR17_FINAL_VALUE: .dword 0
GPR18_FINAL_VALUE: .dword 0
GPR19_FINAL_VALUE: .dword 0
GPR20_FINAL_VALUE: .dword 0
GPR21_FINAL_VALUE: .dword 0
GPR22_FINAL_VALUE: .dword 0
GPR23_FINAL_VALUE: .dword 0
GPR24_FINAL_VALUE: .dword 0
GPR25_FINAL_VALUE: .dword 0
GPR26_FINAL_VALUE: .dword 0
GPR27_FINAL_VALUE: .dword 0
GPR28_FINAL_VALUE: .dword 0
GPR29_FINAL_VALUE: .dword 0
GPR30_FINAL_VALUE: .dword 0
GPR31_FINAL_VALUE: .dword 0

.section .rodata
.align 3
FPR00_FINAL_VALUE: .dword 0
FPR01_FINAL_VALUE: .dword 0
FPR02_FINAL_VALUE: .dword 0
FPR03_FINAL_VALUE: .dword 0
FPR04_FINAL_VALUE: .dword 0
FPR05_FINAL_VALUE: .dword 0
FPR06_FINAL_VALUE: .dword 0
FPR07_FINAL_VALUE: .dword 0
FPR08_FINAL_VALUE: .dword 0
FPR09_FINAL_VALUE: .dword 0
FPR10_FINAL_VALUE: .dword 0
FPR11_FINAL_VALUE: .dword 0
FPR12_FINAL_VALUE: .dword 0
FPR13_FINAL_VALUE: .dword 0
FPR14_FINAL_VALUE: .dword 0
FPR15_FINAL_VALUE: .dword 0
FPR16_FINAL_VALUE: .dword 0
FPR17_FINAL_VALUE: .dword 0
FPR18_FINAL_VALUE: .dword 0
FPR19_FINAL_VALUE: .dword 0
FPR20_FINAL_VALUE: .dword 0
FPR21_FINAL_VALUE: .dword 0
FPR22_FINAL_VALUE: .dword 0
FPR23_FINAL_VALUE: .dword 0
FPR24_FINAL_VALUE: .dword 0
FPR25_FINAL_VALUE: .dword 0
FPR26_FINAL_VALUE: .dword 0
FPR27_FINAL_VALUE: .dword 0
FPR28_FINAL_VALUE: .dword 0
FPR29_FINAL_VALUE: .dword 0
FPR30_FINAL_VALUE: .dword 0
FPR31_FINAL_VALUE: .dword 0

.section .rodata
.align 3
MEM00_FINAL_VALUE: .byte 0
MEM01_FINAL_VALUE: .byte 0
MEM02_FINAL_VALUE: .byte 0
MEM03_FINAL_VALUE: .byte 0
MEM04_FINAL_VALUE: .byte 0
MEM05_FINAL_VALUE: .byte 0
MEM06_FINAL_VALUE: .byte 0
MEM07_FINAL_VALUE: .byte 0
MEM08_FINAL_VALUE: .byte 0
MEM09_FINAL_VALUE: .byte 0
MEM10_FINAL_VALUE: .byte 0
MEM11_FINAL_VALUE: .byte 0
MEM12_FINAL_VALUE: .byte 0
MEM13_FINAL_VALUE: .byte 0
MEM14_FINAL_VALUE: .byte 0
MEM15_FINAL_VALUE: .byte 0
MEM16_FINAL_VALUE: .byte 0
MEM17_FINAL_VALUE: .byte 0
MEM18_FINAL_VALUE: .byte 0
MEM19_FINAL_VALUE: .byte 0
MEM20_FINAL_VALUE: .byte 0
MEM21_FINAL_VALUE: .byte 0
MEM22_FINAL_VALUE: .byte 0
MEM23_FINAL_VALUE: .byte 0
MEM24_FINAL_VALUE: .byte 0
MEM25_FINAL_VALUE: .byte 0
MEM26_FINAL_VALUE: .byte 0
MEM27_FINAL_VALUE: .byte 0
MEM28_FINAL_VALUE: .byte 0
MEM29_FINAL_VALUE: .byte 0
MEM30_FINAL_VALUE: .byte 0
MEM31_FINAL_VALUE: .byte 0

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
MEM14_WRITE_VALUE: .byte 0
MEM15_WRITE_VALUE: .byte 0
MEM16_WRITE_VALUE: .byte 0
MEM17_WRITE_VALUE: .byte 0
MEM18_WRITE_VALUE: .byte 0
MEM19_WRITE_VALUE: .byte 0
MEM20_WRITE_VALUE: .byte 0
MEM21_WRITE_VALUE: .byte 0
MEM22_WRITE_VALUE: .byte 0
MEM23_WRITE_VALUE: .byte 0
MEM24_WRITE_VALUE: .byte 0
MEM25_WRITE_VALUE: .byte 0
MEM26_WRITE_VALUE: .byte 0
MEM27_WRITE_VALUE: .byte 0
MEM28_WRITE_VALUE: .byte 0
MEM29_WRITE_VALUE: .byte 0
MEM30_WRITE_VALUE: .byte 0
MEM31_WRITE_VALUE: .byte 0

.section .text
main:
    j pass

.section .text
pass:
    addi a0, zero, 0
    j exit

.section .text
fail:
    addi a0, zero, 1
    j exit

.section .text
exit:
    ret
