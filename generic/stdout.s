.section .data
.align 3
.global tohost
tohost: .dword 0      # Used to signal test completion to the host.

.section .data
.align 3
.global fromhost
fromhost: .dword 0    # Not used in this test.

.section .data
.align 3
.global putchar_stdout
putchar_stdout: .dword 0 # Address where characters written will be interpreted as stdout.

.section .data
.align 3
MEM00_WRITE_VALUE: .byte 0 # Buffer to store the output string for verification.
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

.section .text
.align 3
.global _start
_start:
    # Initialize pointers.
    la t0, putchar_stdout   # t0 = address of putchar_stdout (for simulated output).
    la a0, hello_string      # a0 = address of the string to print.
    la a1, MEM00_WRITE_VALUE # a1 = address of the memory buffer for verification.

    # Loop to print the string character by character.
print_loop:
    lb t1, 0(a0)            # Load a byte from the string into t1.
    sb t1, 0(t0)            # "Print" the character by writing it to putchar_stdout.
    sb t1, 0(a1)            # Also store the character in our memory buffer.
    addi a0, a0, 1          # Increment the string pointer.
    addi a1, a1, 1          # Increment the buffer pointer.
    beqz t1, end_program    # If the character was a null terminator, end the loop.
    j print_loop            # Otherwise, continue to the next character.

end_program:
    # Signal test completion to the host.
    fence
    li a0, 1                # Use 1 to indicate success.
    la t0, tohost           # Load address of tohost.
    sw a0, 0(t0)            # Write success code to tohost.
    fence

_forever_loop:
    # Infinite loop to halt the processor after the test is done.
    j _forever_loop

.section .rodata
hello_string: .asciz "Hello World!\n" # Null-terminated string to be printed.

.section .rodata
.align 3
# Expected final values in the memory buffer after printing.
# The test framework will compare the buffer against these values.
MEM00_FINAL_VALUE: .ascii "H"  # Expected value at MEM00_WRITE_VALUE
MEM01_FINAL_VALUE: .ascii "e"  # Expected value at MEM01_WRITE_VALUE
MEM02_FINAL_VALUE: .ascii "l"  # etc.
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
MEM13_FINAL_VALUE: .byte 0     # Null terminator.
