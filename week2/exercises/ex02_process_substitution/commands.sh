#!/usr/bin/env bash

echo "===== printenv ====="
printenv | sort | head

echo
echo "===== export ====="
export | sort | head

echo
echo "===== process substitution path ====="
echo <(printenv)

echo
echo "===== diff result (first 20 lines) ====="
diff <(printenv | sort) <(export | sort) | head -20 || true

echo
echo "===== simple process substitution test ====="
cat <(printf "Process substitution works\n")
