#!/usr/bin/env bash

set -euo pipefail

DATA="/tmp/ex07_benchmark.log"
LINES=600000

echo "===== Generate deterministic dataset ====="

python3 generate_data.py "$DATA" "$LINES"


echo
echo "===== Dataset ====="

wc -l "$DATA"
du -h "$DATA"


echo
echo "===== Verify grep result ====="

GREP_COUNT=$(grep -c '^ERROR' "$DATA")

echo "grep count = $GREP_COUNT"


echo
echo "===== Verify ripgrep result ====="

RG_COUNT=$(rg -c '^ERROR' "$DATA")

echo "ripgrep count = $RG_COUNT"


if [[ "$GREP_COUNT" != "$RG_COUNT" ]]; then
    echo "ERROR: commands produced different results"
    exit 1
fi


if [[ "$GREP_COUNT" != "30000" ]]; then
    echo "ERROR: unexpected match count"
    exit 1
fi


echo
echo "===== Hyperfine Benchmark ====="

hyperfine \
    --warmup 2 \
    --runs 8 \
    --export-json benchmark_result.json \
    "grep -c '^ERROR' $DATA" \
    "rg -c '^ERROR' $DATA" \
    | tee benchmark_output.txt


echo
echo "===== Parse benchmark result ====="

python3 - <<'PY'
import json

with open("benchmark_result.json", encoding="utf-8") as f:
    data = json.load(f)

results = data["results"]

if len(results) != 2:
    raise SystemExit("Expected exactly two benchmark results")

grep_result = results[0]
rg_result = results[1]

grep_mean = grep_result["mean"]
grep_median = grep_result["median"]

rg_mean = rg_result["mean"]
rg_median = rg_result["median"]

if grep_mean < rg_mean:
    faster = "grep"
    ratio = rg_mean / grep_mean
elif rg_mean < grep_mean:
    faster = "ripgrep"
    ratio = grep_mean / rg_mean
else:
    faster = "tie"
    ratio = 1.0

with open("summary.txt", "w", encoding="utf-8") as f:
    f.write("Hyperfine Benchmark Summary\n")
    f.write("===========================\n\n")

    f.write(f"grep mean: {grep_mean:.6f} s\n")
    f.write(f"grep median: {grep_median:.6f} s\n")

    f.write(f"ripgrep mean: {rg_mean:.6f} s\n")
    f.write(f"ripgrep median: {rg_median:.6f} s\n")

    f.write("\n")

    if faster == "tie":
        f.write("Faster command: tie\n")
    else:
        f.write(f"Faster command: {faster}\n")
        f.write(f"Approximate speed ratio: {ratio:.2f}x\n")

print(open("summary.txt", encoding="utf-8").read())
PY
