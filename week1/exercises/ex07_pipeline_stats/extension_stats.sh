#!/usr/bin/env bash

echo "=== all sample files ==="
find sample -type f | sort

echo
echo "=== top 5 file extensions ==="

find sample -type f \
| awk -F. 'NF>1 {print "." $NF}' \
| sort \
| uniq -c \
| sort -nr \
| head -5
