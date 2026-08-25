#!/usr/bin/env bash

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: file not found: $file" >&2
    exit 1
fi

echo "Top 2 HTTP 5xx paths:"

awk -F',' '
NR > 1 && $4 ~ /^5[0-9][0-9]$/ {
    count[$3]++
}
END {
    for (path in count) {
        print count[path], path
    }
}
' "$file" | sort -k1,1nr -k2,2 | head -n 2

echo "Average latency_ms:"

awk -F',' '
NR > 1 {
    sum += $5
    count++
}
END {
    if (count > 0) {
        printf "%.2f\n", sum / count
    }
}
' "$file"
