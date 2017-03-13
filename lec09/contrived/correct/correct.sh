#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# Good: we need to save the exit code of `ls` before
# we can test against it multiple times!
ls_exit=$?
if [[ $ls_exit -ne 0 ]]; then
    echo "Error reading the file..."
elif [[ $ls_exit -eq 0 ]]; then
    echo "File information: $contents"
fi
