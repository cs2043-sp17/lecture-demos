#! /usr/bin/env bash
case "$1" in
    "0" )
        echo "0 blargh echoes..."
        ;;
    "1" )
        echo "1 blargh echoes..."
        echo " [1] blargh"
        ;;
    # number or string
    2 )
        echo "2 blargh echoes..."
        echo " [1] blargh"
        echo " [2] blargh"
        ;;
    * )
        echo "Blarghs come in [0-2]."
        exit 1
        ;;
esac
