#! /bin/bash
case "$1" in
    [[:digit:]] )
        echo "$1 blargh echoes..."
        for (( i = 1; i <= $1; i++ )); do
        echo " [$i] blargh"
        done
        ;;
    * )
        echo "Blarghs only come in [0-9]."
        exit 1
        ;;
esac
