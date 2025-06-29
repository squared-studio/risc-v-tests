.section .text
.align 3
.global _start
_start:

        la      x31,    TEST_DATA_BEGIN
        addi    x0,     x0,     100
        addi    x1,     x0,     -1
        addi    x2,     x0,     2
#ifdef RV64
        sd      x0,     0(x31)
        sd      x1,     8(x31)
        sd      x2,     16(x31)
#else
        sw      x0,     0(x31)
        sw      x1,     8(x31)
        sw      x2,     16(x31)
#endif

        fence
        addi    x30,    x0,     1
        la      x31,    tohost
        sw      x30,    0(x31)
        fence

_forever_loop:

        j       _forever_loop


.section .data
.align 3
TEST_DATA_BEGIN:
########################################
.dword 0, 0, 0
########################################
TEST_DATA_END:

.section .data
.align 3
.global tohost
tohost: .dword 0

.section .data
.align 3
.global fromhost
fromhost: .dword 0
