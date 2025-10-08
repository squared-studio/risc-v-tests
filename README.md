<<<<<<< HEAD
# RISC-V-TESTS
=======
# RISC-V Tests

This repository contains a comprehensive collection of **RISC-V assembly tests** designed to validate the functionality and correctness of various instructions and features across the RISC-V architecture. These tests are particularly useful for verifying RISC-V processor implementations or custom instruction set extensions.

## Directory Structure

- **`build/`**: This directory is used to store all intermediate and final build artifacts, such as compiled executables and log files, generated during the testing process.
- **`generic/`**: Contains general-purpose tests that are not specific to a particular instruction set extension (e.g., GPR tests, stdout tests).
- **`rv32i/`**: Contains assembly tests specifically for the **RV32I** (32-bit Integer) instruction set.
- **`rv64i/`**: Contains assembly tests specifically for the **RV64I** (64-bit Integer) instruction set.
- **`test_data/`**: Stores extracted data from test runs, organized by test and architecture. This data can be used for regression checking or further analysis.
- **`spike.ld`**: The linker script used when compiling tests for execution on the Spike RISC-V ISA simulator. It defines the memory layout and entry point for the test programs.

## Prerequisites

- RISC-V GNU Toolchain
- Spike simulator

To run these tests, you will need the RISC-V GNU Toolchain (for assembly and linking) and the Spike RISC-V ISA simulator. You can typically obtain these from the official RISC-V website or your distribution's package manager.

## Usage

All commands are run via `make`. You can see a full list of commands and customizable variables by running `make help`.

### Building a Test
Specify the test file to build using the `TEST` variable and run the `test` target:
```bash
make test TEST=rv32i/addi.s
```

### Running Tests in Spike

To run a specific test on the Spike simulator, provide the relative path to the test file using the `TEST` variable.

Specify the test file to build using the `TEST` variable and run the `spike` target:
```bash
make spike TEST=rv32i/addi.s
```

### Cleaning Build Artifacts

Run the `clean` target to remove all build artifacts:
```bash
make clean
```

### Displaying Help

Run the `help` target to display available commands:
```bash
make help
```

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues or pull requests to improve the tests or add new ones.

## Contact

For questions or feedback, please contact the repository owner.
>>>>>>> bdedc1de6f4186c33f706bb212726d99917deb85
