#!/bin/bash

echo -n "Updating regression script ... "

echo "name: Run Regression Tests"                                  > ./.github/workflows/run-regression.yml
echo ""                                                           >> ./.github/workflows/run-regression.yml
echo "on:"                                                        >> ./.github/workflows/run-regression.yml
echo "  push:"                                                    >> ./.github/workflows/run-regression.yml
echo "    branches: [ \"main\" ]"                                 >> ./.github/workflows/run-regression.yml
echo "  pull_request:"                                            >> ./.github/workflows/run-regression.yml
echo "    branches: [ \"main\" ]"                                 >> ./.github/workflows/run-regression.yml
echo ""                                                           >> ./.github/workflows/run-regression.yml
echo "jobs:"                                                      >> ./.github/workflows/run-regression.yml
echo "  regression-tests:"                                        >> ./.github/workflows/run-regression.yml
echo "    runs-on: [make]"                                        >> ./.github/workflows/run-regression.yml
echo "    # runs-on: [make, spike]"                               >> ./.github/workflows/run-regression.yml
echo "    strategy:"                                              >> ./.github/workflows/run-regression.yml
echo "      matrix:"                                              >> ./.github/workflows/run-regression.yml
echo "        test:"                                              >> ./.github/workflows/run-regression.yml

LIST=""
LIST="$LIST $(find generic -type f)"
LIST="$LIST $(find rv32i -type f)"
LIST="$LIST $(find rv64i -type f)"

for file in $LIST; do
  test_name=$(echo "$file")
  echo "          - $test_name"                               >> ./.github/workflows/run-regression.yml
done

echo ""                                                           >> ./.github/workflows/run-regression.yml
echo "    steps:"                                                 >> ./.github/workflows/run-regression.yml
echo "      - name: Checkout repository"                          >> ./.github/workflows/run-regression.yml
echo "        uses: actions/checkout@v3"                          >> ./.github/workflows/run-regression.yml
echo "      - name: Run test for \${{ matrix.test }}"             >> ./.github/workflows/run-regression.yml
echo "        run: echo \"make spike TEST=\${{ matrix.test }}\""  >> ./.github/workflows/run-regression.yml
echo "        # run: make spike TEST=\${{ matrix.test }}"         >> ./.github/workflows/run-regression.yml
echo ""                                                           >> ./.github/workflows/run-regression.yml

echo -e "\033[1;32mDone\033[0m"
