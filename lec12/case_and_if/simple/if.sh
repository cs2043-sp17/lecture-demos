#! /usr/bin/env bash
#
# (empty to fill space in minted)
# (empty to fill space in minted)
#
if [[ "$1" == "0" ]]; then
    echo "0 blargh echoes..."
elif [[ "$1" == "1" ]]; then
    echo "1 blargh echoes..."
    echo " [1] blargh"
# number or string
elif [[ "$1" -eq 2 ]]; then
    echo "2 blargh echoes..."
    echo " [1] blargh"
    echo " [2] blargh"
else
    echo "Blarghs come in [0-2]."
    exit 1
fi
