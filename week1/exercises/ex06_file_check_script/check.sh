#!/usr/bin/env bash

file="$1"

if [ -f "$file" ]; then
    echo "exists: $file"
    exit 0
else
    echo "missing: $file" >&2
    exit 1
fi
