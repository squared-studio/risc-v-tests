# RISC-V Tests

This repository contains a collection of RISC-V assembly tests designed to validate the functionality of various instructions and features of the RISC-V architecture. It includes tests for both RV32I and RV64I instruction sets, as well as generic tests and templates.

## Directory Structure

- **`rv32i/`**: Contains tests for the RV32I instruction set.
- **`rv64i/`**: Contains tests for the RV64I instruction set.
- **`generic/`**: Contains generic tests.
- **`build/`**: Directory for build artifacts generated during testing.
- **`template.s`**: A template file for creating new tests.
- **`spike.ld`**: Linker script for Spike simulator.

## Prerequisites

- RISC-V GNU Toolchain
- Spike simulator

## Usage

### Building Tests
Specify the test file to build using the `TEST` variable and run the `test` target:
```bash
make test TEST=rv32i/addi.s
```

### Running Tests in Spike

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
