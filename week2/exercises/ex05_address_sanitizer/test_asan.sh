#!/usr/bin/env bash

set -u

echo "===== Compile buggy program ====="

gcc \
    -Wall \
    -Wextra \
    -Wpedantic \
    -g \
    -O0 \
    -fsanitize=address \
    -fno-omit-frame-pointer \
    uaf.c \
    -o uaf_asan


echo
echo "===== Run buggy program ====="

set +e
ASAN_OPTIONS=detect_leaks=0 \
./uaf_asan > asan_output.txt 2>&1
BUG_STATUS=$?
set -e

echo "buggy exit code = $BUG_STATUS"


if grep -q 'heap-use-after-free' asan_output.txt; then
    echo "PASS: heap-use-after-free detected"
else
    echo "FAIL: AddressSanitizer did not detect heap-use-after-free"
    exit 1
fi


if [[ "$BUG_STATUS" -ne 0 ]]; then
    echo "PASS: buggy program returned a non-zero status"
else
    echo "FAIL: buggy program unexpectedly returned zero"
    exit 1
fi


echo
echo "===== Compile fixed program ====="

gcc \
    -Wall \
    -Wextra \
    -Wpedantic \
    -g \
    -O0 \
    -fsanitize=address \
    -fno-omit-frame-pointer \
    fixed.c \
    -o fixed_asan


echo
echo "===== Run fixed program ====="

set +e
ASAN_OPTIONS=detect_leaks=0 \
./fixed_asan > fixed_output.txt 2>&1
FIXED_STATUS=$?
set -e

cat fixed_output.txt

echo "fixed exit code = $FIXED_STATUS"


if [[ "$FIXED_STATUS" -eq 0 ]]; then
    echo "PASS: fixed program returned zero"
else
    echo "FAIL: fixed program returned a non-zero status"
    exit 1
fi


if grep -q 'ERROR: AddressSanitizer' fixed_output.txt; then
    echo "FAIL: AddressSanitizer still reports an error"
    exit 1
else
    echo "PASS: fixed program has no AddressSanitizer error"
fi


if grep -q 'Saved value = 30' fixed_output.txt; then
    echo "PASS: fixed program produced the expected result"
else
    echo "FAIL: fixed program produced an unexpected result"
    exit 1
fi


echo
echo "All AddressSanitizer tests passed."
