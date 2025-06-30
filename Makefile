SHELL := /bin/bash

.DEFAULT_GOAL := help

DEBUG ?= 0

MARCH ?= rv64g

MABI ?= lp64

SPIKE_FLAGS += -l --log-commits
ifeq ($(DEBUG), 1)
	SPIKE_FLAGS += -d
	LOG_FLASG :=
else
	LOG_FLASG := 2>&1 | tee build/${TEST}/spike
endif

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

build:
	@echo -e -n "\033[3;35mCreating build directory... \033[0m"
	@mkdir -p build
	@echo "*" > build/.gitignore
	@echo -e "\033[3;32mDone!\033[0m"

.PHONY: clean
clean:
	@echo -e -n "\033[3;35mCleaning build... \033[0m"
	@rm -rf build temp_regression_issues
	@echo -e "\033[3;32mDone!\033[0m"

.PHONY: test
test: build
	@if [ -z ${TEST} ]; then echo -e "\033[1;31mTEST is not set\033[0m"; exit 1; fi
	@if [ ! -f $(TEST) ]; then echo -e "\033[1;31m$(TEST) does not exist\033[0m"; exit 1; fi
	@echo -e "\033[1;35mBuilding test... \033[0m"
	@rm -rf build/${TEST}
	@mkdir -p build/${TEST}
	@${RISCV64_GCC} -march=$(MARCH) -mabi=$(MABI) -nostdlib -nostartfiles -I include -o build/${TEST}/elf ${TEST} -T spike.ld 2>&1 | tee build/${TEST}/log
	@${RISCV64_OBJCOPY} -O verilog build/${TEST}/elf build/${TEST}/hex
	@${RISCV64_NM} build/${TEST}/elf > build/${TEST}/sym
	@${RISCV64_OBJDUMP} -d build/${TEST}/elf > build/${TEST}/dump
	@echo -e "\033[1;35mBuild test complete!\033[0m"

.PHONY: code
code:
	@if [ ! -f $(TEST) ]; then \
		mkdir -p $(shell echo "${TEST}" | sed "s/\/[^\/]*$$//g"); \
		cp .github/template.s ${TEST}; \
		sed -i "s/#  Author: Name (email)/#  Author: $(shell git config user.name) ($(shell git config user.email))/g" ${TEST}; \
		sed -i "s/#  Copyright (c) YYYY squared-studio/#  Copyright (c) $(shell date +%Y) squared-studio/g" ${TEST}; \
	fi
	@code ${TEST}

.PHONY: spike
spike:
	@make -s test TEST=${TEST}
	@echo -e "\033[1;35mRunning spike... \033[0m"
	@${SPIKE} ${SPIKE_FLAGS} --isa=$(MARCH) --pc=0x800000000 -m0x800000000:0x8000000 build/${TEST}/elf ${LOG_FLASG}
	@echo -e "\033[1;35mspike run complete!\033[0m"
	@cat build/${TEST}/spike >> build/${TEST}/log || echo -n ""
	@cat build/${TEST}/spike | grep ") mem 0x" | sed "s/.*mem 0x/@/g"> build/${TEST}/mem_writes || echo -n ""
	@python ./test_data_extract.py -t ${TEST}
	@rm -rf build/${TEST}/spike
	@mkdir -p test_data/${TEST}
	@cp -f build/${TEST}/test_data test_data/${TEST}/${MARCH} || echo -e "\033[1;31mbuild/${TEST}/test_data does not exist\033[0m"


.PHONY: logo
logo:
	@echo -e "\033[1;37m                                    _         _             _ _       \033[0m"
	@echo -e "\033[1;37m ___  __ _ _   _  __ _ _ __ ___  __| |    ___| |_ _   _  __| (_) ___  \033[0m"
	@echo -e "\033[1;37m/ __|/ _' | | | |/ _' | '__/ _ \/ _' |___/ __| __| | | |/ _' | |/ _ \ \033[0m"
	@echo -e "\033[1;36m\__ \ (_| | |_| | (_| | | |  __/ (_| |___\__ \ |_| |_| | (_| | | (_) |\033[0m"
	@echo -e "\033[1;36m|___/\__, |\__,_|\__,_|_|  \___|\__,_|   |___/\__|\__,_|\__,_|_|\___/ \033[0m"
	@echo -e "\033[1;36m        |_|                                                2023-$(shell date +%Y)\033[0m\n"

# > /dev/null 2>&1
