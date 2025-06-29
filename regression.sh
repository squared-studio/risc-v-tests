#!/bin/bash

start_time=$(date +%s)
clear
make -s logo
echo -n -e " $(date +%x\ %H:%M:%S) ---- \033[1;33mCLEANING UP TEMPORATY FILES... \033[0m"
make -s clean > /dev/null 2>&1
end_time=$(date +%s)
time_diff=$((end_time - start_time))
printf "\033[22G%3ds\n" "$time_diff"

TEST=""
TEST="$TEST $(find generic -type f -name '*.S')"
TEST="$TEST $(find rv32i -type f -name '*.S')"
TEST="$TEST $(find rv64i -type f -name '*.S')"

for test in $TEST; do
    start_time=$(date +%s)
    echo -n -e " $(date +%x\ %H:%M:%S) ---- \033[1;33mRunning test: $test... \033[0m"
    timeout 30s make -s spike TEST="$test" &> /dev/null
    end_time=$(date +%s)
    time_diff=$((end_time - start_time))
    printf "\033[22G%3ds\n" "$time_diff"
done

rm -rf temp_regression_issues

grep --include "log" -irw "error" >> temp_regression_issues ./build
grep --include "log" -irw "*** FAILED ***" >> temp_regression_issues ./build

find ./build -type f -name "spike" | sed "s/\/spike/ TIMEDOUT/g" | sed "s/\.\\/build\///g" >> temp_regression_issues

cat temp_regression_issues

echo ""

if [ -z "$(cat temp_regression_issues)" ]; then
    echo -e "\033[7;32m*** REGRESSION PASSED ***\033[0m";
    exit 0;
else
    echo -e "\033[7;31m*** REGRESSION FAILED ***\033[0m";
    exit 1;
fi
