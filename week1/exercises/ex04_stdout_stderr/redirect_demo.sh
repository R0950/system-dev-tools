#!/usr/bin/env bash

echo "=== separate stdout and stderr ==="

ls /tmp /definitely-not-exist > stdout.txt 2> stderr.txt

echo "--- stdout.txt ---"
cat stdout.txt

echo
echo "--- stderr.txt ---"
cat stderr.txt

echo
echo "=== merged stdout and stderr ==="

ls /tmp /definitely-not-exist > all.txt 2>&1

cat all.txt
