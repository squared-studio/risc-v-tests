# Simple test for branch equal
# Author : Samia Alam (samia.alam.pushpa@gmail.com)

# Testing beq
# Exit Code 0: Pass
# Exit Code 1: Fail. Branch working improper
# Exit Code 2: Fail. Branch not working at all

main:
    addi    t0, x0, 41
    addi    t1, x0, 42
    addi    t2, x0, 41
    beq     t0, t1, line_fail
    beq     t0, t2, line_pass
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
