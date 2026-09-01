#!/usr/bin/env bash

set -u

SESSION="week2demo"

echo "===== TEST SESSION ====="

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "PASS: tmux session exists"
else
    echo "FAIL: tmux session does not exist"
    exit 1
fi


echo
echo "===== TEST WINDOW COUNT ====="

WINDOW_COUNT=$(
    tmux list-windows \
        -t "$SESSION" \
        -F '#{window_id}' \
        | wc -l
)

echo "window count = $WINDOW_COUNT"

if [[ "$WINDOW_COUNT" -eq 2 ]]; then
    echo "PASS: session contains two windows"
else
    echo "FAIL: expected two windows"
    exit 1
fi


echo
echo "===== TEST EDITOR WINDOW ====="

if tmux list-windows \
    -t "$SESSION" \
    -F '#{window_name}' \
    | grep -qx 'editor'
then
    echo "PASS: editor window exists"
else
    echo "FAIL: editor window missing"
    exit 1
fi


echo
echo "===== TEST LOGS WINDOW ====="

if tmux list-windows \
    -t "$SESSION" \
    -F '#{window_name}' \
    | grep -qx 'logs'
then
    echo "PASS: logs window exists"
else
    echo "FAIL: logs window missing"
    exit 1
fi


echo
echo "===== TEST EDITOR PANES ====="

EDITOR_COUNT=$(
    tmux list-panes \
        -t "$SESSION:editor" \
        -F '#{pane_id}' \
        | wc -l
)

echo "editor pane count = $EDITOR_COUNT"

if [[ "$EDITOR_COUNT" -eq 2 ]]; then
    echo "PASS: editor contains two panes"
else
    echo "FAIL: editor pane count incorrect"
    exit 1
fi


echo
echo "===== TEST LOG PANES ====="

LOG_COUNT=$(
    tmux list-panes \
        -t "$SESSION:logs" \
        -F '#{pane_id}' \
        | wc -l
)

echo "logs pane count = $LOG_COUNT"

if [[ "$LOG_COUNT" -eq 2 ]]; then
    echo "PASS: logs contains two panes"
else
    echo "FAIL: logs pane count incorrect"
    exit 1
fi


echo
echo "===== TEST LEFT PANE COMMAND ====="

if grep -q 'LEFT_PANE_READY' editor_left.txt; then
    echo "PASS: left pane command executed"
else
    echo "FAIL: left pane command missing"
    exit 1
fi


echo
echo "===== TEST RIGHT PANE COMMAND ====="

if grep -q 'RIGHT_PANE_READY' editor_right.txt; then
    echo "PASS: right pane command executed"
else
    echo "FAIL: right pane command missing"
    exit 1
fi


echo
echo "===== TEST LOG WINDOW ====="

if grep -q 'LOG_WINDOW_READY' logs_first.txt; then
    echo "PASS: first log pane command executed"
else
    echo "FAIL: first log pane output missing"
    exit 1
fi


echo
echo "===== TEST SECOND LOG PANE ====="

if grep -q 'SECOND_LOG_PANE_READY' logs_second.txt; then
    echo "PASS: second log pane command executed"
else
    echo "FAIL: second log pane output missing"
    exit 1
fi


echo
echo "===== TEST DETACHED SESSION ====="

ATTACHED=$(
    tmux display-message \
        -p \
        -t "$SESSION" \
        '#{session_attached}'
)

echo "attached clients = $ATTACHED"

if [[ "$ATTACHED" -eq 0 ]]; then
    echo "PASS: session is detached"
else
    echo "FAIL: session is attached"
    exit 1
fi


echo
echo "All tmux tests passed."
