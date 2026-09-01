#!/usr/bin/env bash

set -euo pipefail


if [[ "$#" -ne 1 ]]; then

    echo "Usage: $0 TARGET_HOME" >&2
    exit 2

fi


TARGET_HOME="$1"


DOTFILES_DIR=$(
    cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles"
    pwd
)


SOURCE_BASHRC="$DOTFILES_DIR/bashrc"

TARGET_BASHRC="$TARGET_HOME/.bashrc"


echo "Dotfiles directory:"
echo "$DOTFILES_DIR"

echo
echo "Target home:"
echo "$TARGET_HOME"


mkdir -p "$TARGET_HOME"


# ------------------------------------------------------------
# 如果已经存在普通文件，则备份。
# ------------------------------------------------------------

if [[ -e "$TARGET_BASHRC" &&
      ! -L "$TARGET_BASHRC" ]]; then

    BACKUP="$TARGET_BASHRC.backup"

    echo
    echo "Backing up existing .bashrc to:"
    echo "$BACKUP"

    mv \
        "$TARGET_BASHRC" \
        "$BACKUP"

fi


# ------------------------------------------------------------
# 创建符号链接
# ------------------------------------------------------------

ln \
    -sfn \
    "$SOURCE_BASHRC" \
    "$TARGET_BASHRC"


echo
echo "Created symbolic link:"

ls -l "$TARGET_BASHRC"


echo
echo "Installation complete."
