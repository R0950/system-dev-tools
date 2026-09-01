#!/usr/bin/env bash

set -euo pipefail


TEST_HOME="/tmp/ex11_auto_home"

rm -rf "$TEST_HOME"

mkdir -p "$TEST_HOME"


cleanup() {

    rm -rf "$TEST_HOME"

}

trap cleanup EXIT


echo "===== Install dotfiles ====="

./install.sh "$TEST_HOME" >/tmp/ex11_install.txt


echo
echo "===== Check symlink ====="

if [[ -L "$TEST_HOME/.bashrc" ]]; then

    echo "PASS: .bashrc symlink created"

else

    echo "FAIL: .bashrc symlink missing"
    exit 1

fi


EXPECTED=$(
    realpath dotfiles/bashrc
)

ACTUAL=$(
    realpath "$TEST_HOME/.bashrc"
)


if [[ "$EXPECTED" == "$ACTUAL" ]]; then

    echo "PASS: symlink points to correct dotfile"

else

    echo "FAIL: incorrect symlink target"
    exit 1

fi


echo
echo "===== Check dc alias ====="

HOME="$TEST_HOME" \
bash \
    --noprofile \
    --rcfile "$TEST_HOME/.bashrc" \
    -ic '
        cd /
        dc /tmp
        printf "RESULT=%s\n" "$PWD"
    ' \
    >/tmp/ex11_shell.txt \
    2>/tmp/ex11_shell_err.txt


if grep -q \
    '^RESULT=/tmp$' \
    /tmp/ex11_shell.txt
then

    echo "PASS: dc alias works"

else

    echo "FAIL: dc alias does not work"
    exit 1

fi


echo
echo "===== Check aliases ====="

if grep -q \
    "alias dc='cd'" \
    dotfiles/bashrc
then

    echo "PASS: dc is defined as an alias"

else

    echo "FAIL: dc alias definition missing"
    exit 1

fi


if grep -q \
    "alias ll='ls -lah'" \
    dotfiles/bashrc
then

    echo "PASS: ll alias defined"

else

    echo "FAIL: ll alias missing"
    exit 1

fi


echo
echo "===== Check customization ====="

if grep -q \
    'export EDITOR=vim' \
    dotfiles/bashrc
then

    echo "PASS: EDITOR configuration exists"

else

    echo "FAIL: EDITOR configuration missing"
    exit 1

fi


if grep -q \
    "^PS1=" \
    dotfiles/bashrc
then

    echo "PASS: PS1 customization exists"

else

    echo "FAIL: PS1 customization missing"
    exit 1

fi


echo
echo "===== Reinstall ====="

./install.sh "$TEST_HOME" >/tmp/ex11_reinstall.txt


if [[ -L "$TEST_HOME/.bashrc" ]]; then

    echo "PASS: installation is repeatable"

else

    echo "FAIL: repeated installation failed"
    exit 1

fi


echo
echo "All dotfiles tests passed."
