#!/usr/bin/env bash

echo "=== exit codes ==="

true
echo "true exit code: $?"

false
echo "false exit code: $?"

echo
echo "=== && operator ==="

true && echo "true && : second command executed"
false && echo "false && : this should not appear"

echo
echo "=== || operator ==="

false || echo "false || : fallback command executed"
true || echo "true || : this should not appear"

echo
echo "=== conditional directory creation ==="

rm -rf demo_dir
[ -d demo_dir ] || mkdir demo_dir
[ -d demo_dir ] && echo "demo_dir exists"

ls -ld demo_dir
