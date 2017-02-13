#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# If there is no real file, exit code is _2_
# Uncomment to verify:
# echo "The exit code of ls was: $?"

# Test expressions return 0 for true, 1 for false
# Some people prefer this shorthand, but I personally
# find it fundamentally unreadable, and only ever
# causes confusion.
test $? -eq 0 && echo "File information: $contents"
test $? -eq 2 && echo "Error reading the file..."
