#!/usr/bin/env bash

set -euo pipefail

DATA="/tmp/ex07_benchmark.log"

echo "===== Re-run benchmark ====="

./run_benchmark.sh >/tmp/ex07_hyperfine_run.txt 2>&1


echo
echo "===== Check benchmark data ====="

if [[ -f "$DATA" ]]; then
    echo "PASS: benchmark dataset exists"
else
    echo "FAIL: benchmark dataset missing"
    exit 1
fi


LINES=$(wc -l < "$DATA")

echo "dataset lines = $LINES"

if [[ "$LINES" -eq 600000 ]]; then
    echo "PASS: dataset contains 600000 lines"
else
    echo "FAIL: dataset line count incorrect"
    exit 1
fi


echo
echo "===== Check grep ====="

GREP_COUNT=$(grep -c '^ERROR' "$DATA")

echo "grep count = $GREP_COUNT"

if [[ "$GREP_COUNT" -eq 30000 ]]; then
    echo "PASS: grep produced expected result"
else
    echo "FAIL: grep result incorrect"
    exit 1
fi


echo
echo "===== Check ripgrep ====="

RG_COUNT=$(rg -c '^ERROR' "$DATA")

echo "ripgrep count = $RG_COUNT"

if [[ "$RG_COUNT" -eq 30000 ]]; then
    echo "PASS: ripgrep produced expected result"
else
    echo "FAIL: ripgrep result incorrect"
    exit 1
fi


echo
echo "===== Compare results ====="

if [[ "$GREP_COUNT" -eq "$RG_COUNT" ]]; then
    echo "PASS: both implementations are equivalent"
else
    echo "FAIL: implementations return different results"
    exit 1
fi


echo
echo "===== Check Hyperfine JSON ====="

if [[ -s benchmark_result.json ]]; then
    echo "PASS: benchmark_result.json generated"
else
    echo "FAIL: benchmark_result.json missing"
    exit 1
fi


python3 - <<'PY'
import json

with open("benchmark_result.json", encoding="utf-8") as f:
    data = json.load(f)

results = data.get("results", [])

if len(results) != 2:
    raise SystemExit("FAIL: expected two benchmark results")

for result in results:
    if result["mean"] <= 0:
        raise SystemExit("FAIL: invalid benchmark mean")

    if result["median"] <= 0:
        raise SystemExit("FAIL: invalid benchmark median")

print("PASS: JSON contains two valid benchmark results")
PY


echo
echo "===== Check summary ====="

if grep -q 'grep mean:' summary.txt &&
   grep -q 'ripgrep mean:' summary.txt &&
   grep -q 'Faster command:' summary.txt
then
    echo "PASS: benchmark summary generated"
else
    echo "FAIL: benchmark summary incomplete"
    exit 1
fi


echo
echo "All Hyperfine tests passed."
