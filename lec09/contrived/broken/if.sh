#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# Bad: we never save $? and this can cause problems
if [[ $? -ne 0 ]]; then
    echo "Error reading the file..."
fi
if [[ $? -eq 0 ]]; then
    # in the case where we gave a bad filename, this still prints!
    echo "File information: $contents"
fi
