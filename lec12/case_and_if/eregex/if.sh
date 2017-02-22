#!/usr/bin/env bash
if [[ "$1" =~ ^[[:digit:]]+$ ]]; then
    echo "$1 blargh echoes..."
    for (( i = 1; i <= $1; i++ )); do
        echo " [$i] blargh"
    done
else
    echo "Blarghs only come in numbers."
    exit 1
fi
