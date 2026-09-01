#!/usr/bin/env bash

source ./marco.sh

echo "===== Initial directory ====="
pwd

echo
echo "===== Save directory ====="
marco

ORIGINAL="$PWD"

echo
echo "===== Move to /tmp ====="
cd /tmp
pwd

echo
echo "===== Return using polo ====="
polo

echo
echo "===== Verify directory ====="
if [[ "$PWD" == "$ORIGINAL" ]]; then
    echo "PASS: polo returned to the saved directory"
else
    echo "FAIL: polo did not return to the saved directory"
    exit 1
fi

echo
echo "===== Test missing saved directory ====="
unset MARCO_DIR

if polo; then
    echo "FAIL: polo should fail when no directory is saved"
    exit 1
else
    echo "PASS: missing saved directory was detected"
fi

echo
echo "===== Test update saved directory ====="
cd /tmp
marco
cd /
polo

if [[ "$PWD" == "/tmp" ]]; then
    echo "PASS: marco updated the saved directory"
else
    echo "FAIL: marco did not update the saved directory"
    exit 1
fi

echo
echo "All tests passed."
