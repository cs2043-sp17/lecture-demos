#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# Test expressions return 0 for true, 1 for false
# Some people prefer this shorthand, but I personally
# find it fundamentally unreadable, and only ever
# causes confusion.

# Note that this example, when we DO give a good filename,
# NOTHING prints!
test $? -ne 0 && echo "Error reading the file..."
# in the case where we gave a bad filename, this still prints!
# the reason: $? now refers to the exit code of the 'echo Error reading the file...'
test $? -eq 0 && echo "File information: $contents"
