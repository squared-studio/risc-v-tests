# Simple test for Jump
# Author : Samia Alam (samia.alam.pushpa@gmail.com)

# Testing beq
# Exit Code 0: Pass
# Exit Code 1: Fail

main:
    li      a0, 0
    j       finish
    li      a0, 1

finish:
    li      a7, 93
    ecall
