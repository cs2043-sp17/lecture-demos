#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# If there is no real file, exit code is _2_
if [[ $? -eq 0 ]]; then
    echo "File information: $contents"
fi
if [[ $? -eq 2 ]]; then
    echo "Error reading the file..."
fi
