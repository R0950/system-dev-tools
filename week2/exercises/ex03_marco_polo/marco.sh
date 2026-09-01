#!/usr/bin/env bash

marco() {
    MARCO_DIR="$PWD"
    export MARCO_DIR
    echo "Saved directory: $MARCO_DIR"
}

polo() {
    if [[ -z "$MARCO_DIR" ]]; then
        echo "Error: no directory has been saved. Run marco first." >&2
        return 1
    fi

    if [[ ! -d "$MARCO_DIR" ]]; then
        echo "Error: saved directory no longer exists: $MARCO_DIR" >&2
        return 1
    fi

    cd "$MARCO_DIR" || return 1
    echo "Returned to: $PWD"
}
