#!/usr/bin/env bash

set -euo pipefail


echo "===== Prepare challenge ====="

cp \
    challenge_start.txt \
    /tmp/ex10_vimgolf_test.txt


echo
echo "===== Check initial file ====="

if cmp -s \
    /tmp/ex10_vimgolf_test.txt \
    challenge_expected.txt
then

    echo "FAIL: initial file is already solved"
    exit 1

else

    echo "PASS: initial file is unsolved"

fi


echo
echo "===== Execute Vim ====="

vim \
    -Nu NONE \
    -n \
    -es \
    /tmp/ex10_vimgolf_test.txt \
    -S "$(pwd)/solution.vim"


echo "PASS: Vim command executed"


echo
echo "===== Compare target ====="

if cmp -s \
    /tmp/ex10_vimgolf_test.txt \
    challenge_expected.txt
then

    echo "PASS: Vim output matches VimGolf target"

else

    echo "FAIL: Vim output differs from target"

    diff \
        -u \
        /tmp/ex10_vimgolf_test.txt \
        challenge_expected.txt || true

    exit 1

fi


echo
echo "===== Check blank line ====="

LINE5=$(
    sed -n '5p' \
    /tmp/ex10_vimgolf_test.txt
)

if [[ -z "$LINE5" ]]; then

    echo "PASS: blank line preserved"

else

    echo "FAIL: blank line modified"
    exit 1

fi


echo
echo "===== Check semicolons ====="

COUNT=$(
    grep -o ';' \
    /tmp/ex10_vimgolf_test.txt |
    wc -l
)

echo "semicolon count = $COUNT"

if [[ "$COUNT" -eq 6 ]]; then

    echo "PASS: correct number of semicolons"

else

    echo "FAIL: incorrect semicolon count"
    exit 1

fi


echo
echo "===== Check EOF ====="

python3 - <<'PY'
from pathlib import Path

path = Path("/tmp/ex10_vimgolf_test.txt")

if path.read_bytes().endswith(b"\n"):
    raise SystemExit("FAIL: trailing newline detected")

print("PASS: EOF matches challenge")
PY


rm -f /tmp/ex10_vimgolf_test.txt


echo
echo "All VimGolf tests passed."
