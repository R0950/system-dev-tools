#!/usr/bin/env bash

name="hello world"

echo "=== single quotes ==="
echo '$name'

echo
echo "=== double quotes ==="
echo "$name"

echo
echo "=== unquoted variable ==="
printf '<%s>\n' $name

echo
echo "=== double-quoted variable ==="
printf '<%s>\n' "$name"

echo
echo "=== ANSI-C quotes ==="
printf '%s\n' $'first line\nsecond line\tTAB'

echo
echo "=== escape comparison ==="
echo 'hello\nworld'
echo "hello\nworld"
printf '%s\n' $'hello\nworld'
