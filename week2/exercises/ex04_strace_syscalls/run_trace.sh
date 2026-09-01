#!/usr/bin/env bash

echo "===== Normal ls ====="
ls -l demo

echo
echo "===== Full strace ====="
strace -o trace_all.txt ls -l demo >/dev/null
echo "trace lines:"
wc -l trace_all.txt

echo
echo "===== File related calls ====="
strace -e trace=file -o trace_file.txt ls -l demo >/dev/null
head -10 trace_file.txt

echo
echo "===== openat calls ====="
strace -e trace=openat -o trace_openat.txt ls -l demo >/dev/null
head -10 trace_openat.txt

echo
echo "===== System call statistics ====="
strace -c -o syscall_summary.txt ls -l demo >/dev/null
cat syscall_summary.txt

echo
echo "===== Follow child processes ====="
strace -f -o script_trace.txt ./demo/run_demo.sh >/dev/null

if grep -q 'alpha.txt' script_trace.txt; then
    echo "PASS: alpha.txt access detected"
else
    echo "FAIL: alpha.txt access not detected"
    exit 1
fi

echo
echo "===== Missing file ====="
strace -e trace=openat \
    -o missing_file_trace.txt \
    cat demo/not_exist.txt >/dev/null 2>&1 || true

if grep -q 'ENOENT' missing_file_trace.txt; then
    echo "PASS: ENOENT detected"
else
    echo "FAIL: ENOENT not detected"
    exit 1
fi

echo
echo "All strace tests passed."
