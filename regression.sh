#!/bin/bash

clear;
make -s logo

make -s clean

TEST=""
TEST="$TEST $(find generic -type f)"
TEST="$TEST $(find rv32i -type f)"
TEST="$TEST $(find rv64i -type f)"

for test in $TEST; do
    echo "Running test: $test"
    make -s spike TEST="$test"
done

clear
make -s logo

rm -rf temp_regression_issues

grep --include "log" -irw "error" >> temp_regression_issues ./build
grep --include "log" -irw "*** FAILED ***" >> temp_regression_issues ./build

cat temp_regression_issues

echo ""

if [ -z "$(cat temp_regression_issues)" ]; then
    echo -e "\033[7;32m*** REGRESSION PASSED ***\033[0m";
    exit 0;
else
    echo -e "\033[7;31m*** REGRESSION FAILED ***\033[0m";
    exit 1;
fi
