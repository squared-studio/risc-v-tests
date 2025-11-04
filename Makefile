# ==============================================================================
# RISC-V Test Build System
# ==============================================================================
# This Makefile provides targets for building and running RISC-V tests using
# the Spike simulator and RISC-V GCC toolchain.
# ==============================================================================

# Use bash as the shell for all commands
SHELL := /bin/bash

# Default target when 'make' is run without arguments
.DEFAULT_GOAL := help

# ==============================================================================
# Configuration Variables
# ==============================================================================

# Debug mode flag: Set to 1 to enable Spike's interactive debug mode
DEBUG ?= 0

# Target RISC-V architecture (e.g., rv32i, rv32g, rv64i, rv64g)
MARCH ?= rv64g

# Target ABI (Application Binary Interface)
# Common values: ilp32 (32-bit), lp64 (64-bit)
MABI ?= lp64

# Spike simulator flags configuration
# Enable logging and commit tracking
SPIKE_FLAGS += -l --log-commits
ifeq ($(DEBUG), 1)
	# Add debug flag for interactive mode
	SPIKE_FLAGS += -d
	# Empty - no output redirection in debug mode
	LOG_FLAGS :=
else
	# Redirect output to both terminal and spike log file
	LOG_FLAGS := 2>&1 | tee build/${TEST}/spike
endif

# ==============================================================================
# Toolchain Configuration
# ==============================================================================

# RISC-V GCC compiler
RISCV64_GCC ?= riscv64-unknown-elf-gcc

# Object file copy utility (for creating hex files from ELF)
RISCV64_OBJCOPY ?= riscv64-unknown-elf-objcopy

# Symbol table utility
RISCV64_NM ?= riscv64-unknown-elf-nm

# Disassembler utility
RISCV64_OBJDUMP ?= riscv64-unknown-elf-objdump

# Spike RISC-V ISA simulator
SPIKE ?= spike

# ==============================================================================
# Target: help
# ==============================================================================
# Displays usage information including available targets and variables

.PHONY: help
help: logo
	@echo -e "\033[1;32mAvailable targets:\033[0m"
	@echo -e "\033[1;33m  help  :\033[0m Displays this help message."
	@echo -e "\033[1;33m  test  :\033[0m Builds the test specified by the TEST variable."
	@echo -e "\033[1;33m  spike :\033[0m Compile and run test on Spike simulator."
	@echo -e "\033[1;33m  code  :\033[0m Opens a test file, creating it from a template if it doesn't exist."
	@echo -e "\033[1;33m  clean :\033[0m Removes the build directory and its contents."
	@echo ""
	@echo -e "\033[1;32mVariables:\033[0m"
	@echo -e "\033[1;33m  TEST  :\033[0m Path to the test file. Must be set for 'test', 'spike', and 'code'."
	@echo -e "\033[1;33m  MARCH :\033[0m Target RISC-V architecture (e.g., rv32i, rv64g). Default: '$(MARCH)'."
	@echo -e "\033[1;33m  MABI  :\033[0m Target ABI (e.g., ilp32, lp64). Default: '$(MABI)'."
	@echo -e "\033[1;33m  DEBUG :\033[0m Set to 1 to enable Spike's interactive debug mode. Default: 0."
	@echo ""

# ==============================================================================
# Target: build
# ==============================================================================
# Creates the build directory structure for test artifacts

build:
	@echo -e -n "\033[3;35mCreating build directory... \033[0m"
	@mkdir -p build
	@echo "*" > build/.gitignore
	@echo -e "\033[3;32mDone!\033[0m"

# ==============================================================================
# Target: clean
# ==============================================================================
# Removes all build artifacts and temporary files

.PHONY: clean
clean:
	@echo -e -n "\033[3;35mCleaning build... \033[0m"
	@rm -rf build temp_regression_issues
	@echo -e "\033[3;32mDone!\033[0m"

# ==============================================================================
# Target: test
# ==============================================================================
# Compiles a RISC-V test program and generates various output files:
#   - elf: The executable ELF binary
#   - hex: Verilog-compatible hex format for hardware simulation
#   - sym: Symbol table for debugging
#   - dump: Disassembly listing
#   - log: Compilation log
# Requires: TEST variable pointing to the test source file

.PHONY: test
test: build
	@if [ -z ${TEST} ]; then echo -e "\033[1;31mTEST is not set\033[0m"; exit 1; fi
	@if [ ! -f $(TEST) ]; then echo -e "\033[1;31m$(TEST) does not exist\033[0m"; exit 1; fi
	@echo -e "\033[1;35mBuilding test... \033[0m"
	@rm -rf build/${TEST}
	@mkdir -p build/${TEST}
	# Compile the test with RISC-V GCC (no standard library, bare metal)
	@${RISCV64_GCC} -march=$(MARCH) -mabi=$(MABI) -nostdlib -nostartfiles -I include -o build/${TEST}/elf ${TEST} -T spike.ld 2>&1 | tee build/${TEST}/log
	# Convert ELF to Verilog hex format for hardware simulation
	@${RISCV64_OBJCOPY} -O verilog build/${TEST}/elf build/${TEST}/hex
	# Extract symbol table for debugging
	@${RISCV64_NM} build/${TEST}/elf > build/${TEST}/sym
	# Generate disassembly listing
	@${RISCV64_OBJDUMP} -d build/${TEST}/elf > build/${TEST}/dump
	@echo -e "\033[1;35mBuild test complete!\033[0m"

# ==============================================================================
# Target: code
# ==============================================================================
# Opens a test file in VS Code. If the file doesn't exist, creates it from
# a template with auto-populated author and copyright information.
# Requires: TEST variable pointing to the desired test file path

.PHONY: code
code:
	# Check if test file exists; if not, create from template
	@if [ ! -f $(TEST) ]; then \
		mkdir -p $(shell echo "${TEST}" | sed "s/\/[^\/]*$$//g"); \
		cp .github/template.s ${TEST}; \
		sed -i "s/#  Author: Name (email)/#  Author: $(shell git config user.name) ($(shell git config user.email))/g" ${TEST}; \
		sed -i "s/#  Copyright (c) YYYY squared-studio/#  Copyright (c) $(shell date +%Y) squared-studio/g" ${TEST}; \
	fi
	# Open the test file in VS Code
	@code ${TEST}

# ==============================================================================
# Target: spike
# ==============================================================================
# Builds and runs a test on the Spike RISC-V ISA simulator, then processes
# the output to extract memory write operations and test data.
# Steps:
#   1. Build the test
#   2. Display symbol table
#   3. Run on Spike simulator
#   4. Extract memory writes and test data
#   5. Copy results to test_data directory
# Requires: TEST variable pointing to the test source file

.PHONY: spike
spike:
	# Build the test first
	@make -s test TEST=${TEST}
	# Display the symbol table
	@cat build/${TEST}/sym
	@echo -e "\033[1;35mRunning spike... \033[0m"
	# Run the test on Spike simulator with configured flags
	@${SPIKE} ${SPIKE_FLAGS} --isa=$(MARCH) --pc=0x800000000 -m0x800000000:0x8000000 build/${TEST}/elf ${LOG_FLAGS}
	@echo -e "\033[1;35mspike run complete!\033[0m"
	# Append spike output to compilation log
	@cat build/${TEST}/spike >> build/${TEST}/log || echo -n ""
	# Extract memory write operations from spike output
	@cat build/${TEST}/spike | grep ") mem 0x" | sed "s/.*mem 0x/@/g"> build/${TEST}/mem_writes || echo -n ""
	# Run Python script to extract test data
	@python ./test_data_extract.py -t ${TEST}
	# Clean up temporary spike output file
	@rm -rf build/${TEST}/spike
	# Copy test data to the test_data directory
	@mkdir -p test_data/${TEST}
	@cp -f build/${TEST}/test_data test_data/${TEST}/${MARCH} || echo -e "\033[1;31mbuild/${TEST}/test_data does not exist\033[0m"


# ==============================================================================
# Target: logo
# ==============================================================================
# Displays the squared-studio ASCII art logo with the current year

.PHONY: logo
logo:
	@echo -e "\033[1;37m                                    _         _             _ _       \033[0m"
	@echo -e "\033[1;37m ___  __ _ _   _  __ _ _ __ ___  __| |    ___| |_ _   _  __| (_) ___  \033[0m"
	@echo -e "\033[1;37m/ __|/ _' | | | |/ _' | '__/ _ \/ _' |___/ __| __| | | |/ _' | |/ _ \ \033[0m"
	@echo -e "\033[1;36m\__ \ (_| | |_| | (_| | | |  __/ (_| |___\__ \ |_| |_| | (_| | | (_) |\033[0m"
	@echo -e "\033[1;36m|___/\__, |\__,_|\__,_|_|  \___|\__,_|   |___/\__|\__,_|\__,_|_|\___/ \033[0m"
	@echo -e "\033[1;36m        |_|                                                2023-$(shell date +%Y)\033[0m\n"

# > /dev/null 2>&1
