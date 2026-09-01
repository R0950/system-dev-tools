#!/usr/bin/env bash

set -euo pipefail

PORT=4444
WEBROOT="$(pwd)/webroot"

SERVER_PID=""
DISCOVERED_PID=""

cleanup() {

    if [[ -n "${SERVER_PID:-}" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi

}

trap cleanup EXIT


echo "===== Start server ====="

cd "$WEBROOT"

python3 -m http.server "$PORT" \
    >/tmp/ex08_server_stdout.txt \
    2>/tmp/ex08_server_stderr.txt &

SERVER_PID=$!

cd ..

sleep 2


echo "server PID = $SERVER_PID"


echo
echo "===== Check process ====="

if kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "PASS: server process running"
else
    echo "FAIL: server process not running"
    exit 1
fi


echo
echo "===== Check HTTP ====="

RESPONSE=$(
    curl \
        --connect-timeout 2 \
        -fsS \
        "http://127.0.0.1:$PORT/"
)

if grep -q 'Port 4444 Test' <<< "$RESPONSE"; then
    echo "PASS: HTTP request succeeded"
else
    echo "FAIL: HTTP response incorrect"
    exit 1
fi


echo
echo "===== Find port with ss ====="

SS_RESULT=$(
    ss -tlnp |
    grep ":$PORT"
)

echo "$SS_RESULT"


if grep -q ":$PORT" <<< "$SS_RESULT"; then
    echo "PASS: listening port found"
else
    echo "FAIL: listening port not found"
    exit 1
fi


echo
echo "===== Extract PID ====="

DISCOVERED_PID=$(
    sed -n \
    's/.*pid=\([0-9][0-9]*\).*/\1/p' \
    <<< "$SS_RESULT" \
    | head -1
)

echo "server PID = $SERVER_PID"
echo "ss PID     = $DISCOVERED_PID"


if [[ -z "$DISCOVERED_PID" ]]; then
    echo "FAIL: PID extraction failed"
    exit 1
fi


if [[ "$DISCOVERED_PID" == "$SERVER_PID" ]]; then
    echo "PASS: ss identified correct process"
else
    echo "FAIL: ss identified different process"
    exit 1
fi


echo
echo "===== Terminate discovered process ====="

kill "$DISCOVERED_PID"

wait "$SERVER_PID" 2>/dev/null || true

SERVER_PID=""

sleep 1


if kill -0 "$DISCOVERED_PID" 2>/dev/null; then
    echo "FAIL: process still running"
    exit 1
else
    echo "PASS: process terminated"
fi


echo
echo "===== Verify released port ====="

if ss -tlnp | grep -q ":$PORT"; then
    echo "FAIL: port still occupied"
    exit 1
else
    echo "PASS: port released"
fi


echo
echo "All port debugging tests passed."
