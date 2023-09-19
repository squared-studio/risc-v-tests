# Simple test for branch not equal
# Author : Samia Alam (samia.alam.pushpa@gmail.com)

# Testing bne
# Exit Code 0: Pass
# Exit Code 1: Fail. Branch working improper
# Exit Code 2: Fail. Branch not working at all

main:
    addi    t0, x0, 42
    addi    t1, x0, 42
    addi    t2, x0, 41
    bne     t0, t1, line_fail
    bne     t0, t2, line_pass
    addi    a0, x0, 2
    j       finish

line_pass:
    addi    a0, x0, 0
    j       finish

line_fail:
    addi    a0, x0, 1
    j       finish

finish:
    addi    a7, x0, 93
    ecall
