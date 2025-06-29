// This test verifies the ADDI (Add Immediate) instruction's functionality.
// It performs a series of additions with various immediate values, including
// positive, negative, zero, and boundary values. The results of each
// operation are stored sequentially in a dedicated memory region.
// Finally, it signals success to the host environment.

.section .text
.align 3
.global _start

// Macro to store the result from a register to the test data area.
// It automatically handles 32-bit (sw) and 64-bit (sd) architectures
// by checking the `__riscv_xlen` preprocessor variable. After storing,
// it increments the pointer in x31 to the next available slot.
#if __riscv_xlen == 64
#define STORE_X31(REG)                  \
        sd      REG,    0(x31);         \
        addi    x31,    x31,    8;
#else
#define STORE_X31(REG)                  \
        sw      REG,    0(x31);         \
        addi    x31,    x31,    4;
#endif

// A test-specific macro to simplify writing `addi` test cases.
// It executes the `addi` instruction with the given parameters and then
// immediately calls the `STORE_X31` macro to save the result.
#define ADDI(RD, RS, IMM)               \
        addi    RD,     RS,     IMM;    \
        STORE_X31(RD);

_start:
        // Initialize register x31 to point to the beginning of the
        // memory area reserved for storing test results.
        la      x31,    TEST_DATA_BEGIN
        
        // --- Test Cases ---
        // Note: The first test `ADDI(x0, x0, 100)` targets the zero register x0,
        // which is a no-op. The stored result will be 0.
        ADDI (x0, x0, 100);
        ADDI (x1, x0, -1);
        ADDI (x2, x1, 2);
        ADDI (x3, x1, 0);
        ADDI (x4, x2, 0);
        ADDI (x5, x0, 2047);
        ADDI (x6, x0, -2048);

        // A sequence of operations on the same register (x7) to test dependencies.
        // Initialize x7 to the value of x1 (-1).
        ADDI (x7, x1, 0);
        // Repeatedly add 1 (8 times). Expected final value in x7 is 7.
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        ADDI (x7, x7, 1);
        // Repeatedly subtract 2 (8 times). Expected final value in x7 is -9.
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        ADDI (x7, x7, -2);
        // Repeatedly add 3 (8 times). Expected final value in x7 is 15.
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);
        ADDI (x7, x7, 3);

        // --- Test Completion ---
        // The `fence` instruction ensures that all previous memory write operations
        // (storing test results) have completed before proceeding.
        fence
        // Load the value 1 into x30. This is the standard success code.
        addi    x30,    x0, 1
        // Load the address of the `tohost` symbol into x31.
        la      x31,    tohost
        // Write the success code from x30 to the `tohost` address to signal
        // the test harness that the test has passed.
        sw      x30,    0(x31)
        // A final fence to ensure the write to `tohost` is visible to the host.
        fence

// Undefine the macro to prevent it from leaking into other source files.
#undef STORE_X31

// Halt the processor by entering an infinite loop.
_forever_loop:
        j       _forever_loop

.section .data
.align 3

// Standard symbols for communication with the test harness (e.g., Spike).
.global tohost
tohost: .dword 0

.global fromhost
fromhost: .dword 0

// This label marks the beginning of the memory region for test results.
TEST_DATA_BEGIN:
    // Allocate 32 "slots" of memory, with each slot's size being
    // appropriate for the architecture (4 bytes for RV32, 8 for RV64).
    .zero __riscv_xlen / 8 * 32
TEST_DATA_END:
