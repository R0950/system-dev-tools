#!/usr/bin/env bash

set -euo pipefail


mapfile -t AVAILABLE < <(
python3 - <<'PY'
import os

for cpu in sorted(os.sched_getaffinity(0)):
    print(cpu)
PY
)


HAS0=0
HAS2=0


for CPU in "${AVAILABLE[@]}"; do

    [[ "$CPU" == "0" ]] && HAS0=1
    [[ "$CPU" == "2" ]] && HAS2=1

done


if [[ "$HAS0" -eq 1 &&
      "$HAS2" -eq 1 ]]; then

    CPU_A=0
    CPU_B=2

else

    CPU_A="${AVAILABLE[0]}"
    CPU_B="${AVAILABLE[1]}"

fi


CPU_LIST="$CPU_A,$CPU_B"


STRESS_PID=""


cleanup() {

    if [[ -n "${STRESS_PID:-}" ]]; then

        CHILDREN=$(
            pgrep -P "$STRESS_PID" || true
        )

        if [[ -n "$CHILDREN" ]]; then
            kill $CHILDREN 2>/dev/null || true
        fi

        kill "$STRESS_PID" 2>/dev/null || true

        wait "$STRESS_PID" 2>/dev/null || true

    fi

}


trap cleanup EXIT


echo "===== Start workload ====="


taskset \
    --cpu-list "$CPU_LIST" \
    stress -c 3 \
    >/tmp/ex09_test_stdout.txt \
    2>/tmp/ex09_test_stderr.txt &


STRESS_PID=$!


sleep 3


if kill -0 "$STRESS_PID" 2>/dev/null; then

    echo "PASS: stress running"

else

    echo "FAIL: stress not running"

    exit 1

fi


echo
echo "===== Worker count ====="


mapfile -t WORKERS < <(
    pgrep -P "$STRESS_PID"
)


echo "workers=${#WORKERS[@]}"


if [[ "${#WORKERS[@]}" -eq 3 ]]; then

    echo "PASS: three CPU workers created"

else

    echo "FAIL: incorrect worker count"

    exit 1

fi


echo
echo "===== Affinity ====="


for PID in "$STRESS_PID" "${WORKERS[@]}"; do

    AFFINITY=$(
        taskset -pc "$PID" |
        awk -F': ' '{print $2}'
    )

    echo "PID=$PID affinity=$AFFINITY"


    if [[ "$AFFINITY" != "$CPU_LIST" ]]; then

        echo "FAIL: incorrect CPU affinity"

        exit 1

    fi

done


echo "PASS: all processes restricted correctly"


echo
echo "===== CPU location ====="


for PID in "${WORKERS[@]}"; do

    PSR=$(
        ps -o psr= -p "$PID" |
        tr -d ' '
    )

    echo "PID=$PID CPU=$PSR"


    if [[ "$PSR" != "$CPU_A" &&
          "$PSR" != "$CPU_B" ]]; then

        echo "FAIL: worker outside affinity mask"

        exit 1

    fi

done


echo "PASS: workers observed only on allowed CPUs"


echo
echo "===== Cleanup ====="


CHILDREN=$(
    pgrep -P "$STRESS_PID" || true
)


if [[ -n "$CHILDREN" ]]; then

    kill $CHILDREN 2>/dev/null || true

fi


kill "$STRESS_PID" 2>/dev/null || true

wait "$STRESS_PID" 2>/dev/null || true

STRESS_PID=""


echo "PASS: stress workload stopped"

echo
echo "All CPU affinity tests passed."
