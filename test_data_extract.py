#!/bin/python
import argparse
import sys

# Create the parser
parser = argparse.ArgumentParser(
  description="A script that takes test file paths as arguments."
)

# Add the arguments
parser.add_argument("-t", "--test", required=True, help="test name")

# Parse the arguments from the command line
args = parser.parse_args()

# memory dictionary
mem = {}

# try read mem_writes file line by line
try:
  with open(f"build/{args.test}/mem_writes", 'r') as input_file:
    for line in input_file:
      addr, val = line.split()
      addr = int(addr.replace("@", ""), 16)
      val = val.replace("0x","")
      data_len = int(len(val)/2)
      for i in range(data_len):
        mem[addr+i] = val[(data_len - 1 - i) * 2:(data_len - 1 - i) * 2 + 2]
except FileNotFoundError:
  print(f"Error: The file 'build/{args.test}/mem_writes' was not found.", file=sys.stderr)
  sys.exit(1)

TEST_DATA_BEGIN = 0
TEST_DATA_END = 0

# try read sym file line by line
try:
  with open(f"build/{args.test}/sym", 'r') as input_file:
    for line in input_file:
      addr, sym_typy, val = line.split()
      if (val == "TEST_DATA_BEGIN"):
        TEST_DATA_BEGIN = int(addr, 16)
      if (val == "TEST_DATA_END"):
        TEST_DATA_END = int(addr, 16)
except FileNotFoundError:
  print(f"Error: The file 'build/{args.test}/sym' was not found.", file=sys.stderr)
  sys.exit(1)

# memory sort
mem = dict(sorted(mem.items()))

# Foreach mem[addr] if addr < 0x800000080 delete it
for addr in list(mem.keys()):
  if addr < TEST_DATA_BEGIN:
    del mem[addr]
  if addr >= TEST_DATA_END:
    del mem[addr]

# Store Data in intex hex format in build/{args.test}/test_data
OUTPUT_STRING = ""
CNT = 0
for i in range(TEST_DATA_BEGIN, TEST_DATA_END):
  try:
    OUTPUT_STRING += f"{mem[i]}"
  except KeyError:
    OUTPUT_STRING += f"00"
  if CNT == 15:
    OUTPUT_STRING += f"\n"
    CNT = 0
  else:
    OUTPUT_STRING += f" "
    CNT += 1
OUTPUT_STRING += f"\n"

try:
  with open(f"build/{args.test}/test_data", 'w') as output_file:
    output_file.write(OUTPUT_STRING)
except FileNotFoundError:
  print(f"Error: The file 'build/{args.test}/test_data' was not found.", file=sys.stderr)
  sys.exit(1)