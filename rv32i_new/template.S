// This is a template for a RISC-V instruction test.
// It provides a framework for testing instructions that produce a result
// in a general-purpose register. The results are stored in memory,
// and the test indicates success to the host.

.section .text
.align 3
.global _start

// Macro to store the result from a register to the test data area.
// It automatically handles 32-bit (sw) and 64-bit (sd) architectures.
#if __riscv_xlen == 64
#define STORE_X31(REG)                  \
        sd      REG,    0(x31);         \
        addi    x31,    x31,    8;
#else
#define STORE_X31(REG)                  \
        sw      REG,    0(x31);         \
        addi    x31,    x31,    4;
#endif

// Macro to test an I-type instruction.
// Usage: TEST_I_TYPE(instruction, dest_reg, src_reg, immediate)
#define TEST_I_TYPE(INSTR, RD, RS, IMM) \
        INSTR   RD,     RS,     IMM;    \
        STORE_X31(RD);

// Macro to test an R-type instruction.
// Usage: TEST_R_TYPE(instruction, dest_reg, src_reg1, src_reg2)
#define TEST_R_TYPE(INSTR, RD, RS1, RS2) \
        INSTR   RD,     RS1,    RS2;    \
        STORE_X31(RD);

_start:
        // Initialize pointer to the test data area.
        la      x31,    TEST_DATA_BEGIN

        // -----------------------------------------------------------------
        // Test cases go here.
        // Use the macros defined above to write your test cases.
        //
        // Example for an I-type instruction (e.g., addi):
        // TEST_I_TYPE(addi, x1, x0, 100)
        //
        // Example for an R-type instruction (e.g., add):
        // li x2, 50
        // TEST_R_TYPE(add, x1, x1, x2)
        // -----------------------------------------------------------------

        // Signal test completion to the host.
        fence
        li      x30,    1
        la      x31,    tohost
        sw      x30,    0(x31)
        fence

#undef STORE_X31
#undef TEST_I_TYPE
#undef TEST_R_TYPE

_forever_loop:
        j       _forever_loop

.section .data
.align 3

// Standard symbols for communication with the test harness.
.global tohost
tohost: .dword 0

.global fromhost
fromhost: .dword 0

// Memory area for storing test results.
TEST_DATA_BEGIN:
    // Adjust the size (32) to match the number of test cases.
    .zero __riscv_xlen / 8 * 32
TEST_DATA_END: