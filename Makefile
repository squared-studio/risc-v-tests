INST_BASE ?= 0000000020000000
DATA_BASE ?= 0000000040000000

CLEAN_TARGET += $(shell find $(realpath .) -name "*.dump")
CLEAN_TARGET += $(shell find $(realpath .) -name "*.elf")
CLEAN_TARGET += $(shell find $(realpath .) -name "*.hex")
CLEAN_TARGET += $(shell find $(realpath .) -name "*.o")
CLEAN_TARGET += $(shell find $(realpath .) -name "*.sym")
CLEAN_TARGET += $(shell find $(realpath .) -name "linker.x")

BUILD_PATH = build/$(TEST)

CFLAGS += -Os
# CFLAGS += -g3
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -Wa,-als,-al
CFLAGS += -mno-save-restore
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
CFLAGS += -ffreestanding

.PHONY: build
build: update_linker build/prints.o build/startup.o
	@mkdir -p $(BUILD_PATH)
	@riscv64-unknown-elf-gcc -march=rv64g $(CFLAGS) -c -o $(BUILD_PATH)/$(TEST).o src/$(TEST)
	@riscv64-unknown-elf-gcc -march=rv64g -nostdlib -nostartfiles -Tlinker.x -o $(BUILD_PATH)/$(TEST).elf $(BUILD_PATH)/$(TEST).o build/prints.o build/startup.o
	@riscv64-unknown-elf-objcopy -O verilog $(BUILD_PATH)/$(TEST).elf $(BUILD_PATH)/$(TEST).hex
	@riscv64-unknown-elf-nm $(BUILD_PATH)/$(TEST).elf > $(BUILD_PATH)/$(TEST).sym
	@riscv64-unknown-elf-objdump -d $(BUILD_PATH)/$(TEST).elf > $(BUILD_PATH)/$(TEST).dump

build/prints.o: prints.c
	@mkdir -p build
	@riscv64-unknown-elf-gcc -march=rv64g $(CFLAGS) -c -o build/prints.o prints.c

build/startup.o: startup.s
	@mkdir -p build
	@riscv64-unknown-elf-gcc -march=rv64g $(CFLAGS) -c -o build/startup.o startup.s

.PHONY: clean
clean:
	@$(foreach word, $(CLEAN_TARGET), echo "removing $(word)";)
	@rm -rf $(CLEAN_TARGET)
	@mkdir -p ./build
	@find ./build -type "d" -empty -delete

.PHONY: update_linker
update_linker:
	@cat linker.base \
	  | sed "s/^INST_BASE = 0x.*;/INST_BASE = 0x$(INST_BASE);/g" \
	  | sed "s/^DATA_BASE = 0x.*;/DATA_BASE = 0x$(DATA_BASE);/g" \
	  > linker.x
	
.PHONY: all
all:
	@make clean
	@rm -rf build
	@$(foreach file, $(shell find $(realpath ./src) -name "*.s" -o -name "*.c"), make build TEST=$(shell basename $(file));)
