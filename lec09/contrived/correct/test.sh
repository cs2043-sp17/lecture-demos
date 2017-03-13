#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# Test expressions return 0 for true, 1 for false
# Some people prefer this shorthand, but I personally
# find it fundamentally unreadable, and only ever
# causes confusion.
#
# You will encounter things like this in the wild though,
# and it is worth understanding.  In this case, we do not
# need to save the exit code of `ls` because we only want
# to perform two things: print the $contents, or say error.
#
# This works as follows:
# Check if $? (the exit from ls) is equal (-eq) to 0
#    - 0 means success: && <something> will execute
#        - Read it like a human: test was true? then (&&) do X
#        - do X in this case is echo "File information: $contents"
#    - if the test of $? -eq 0 fails" || <something> will execute
#        - Read it like a human: test was true? else (||) do Y
#        - do Y in this case is echo "Error reading the file..."
#
# So in the end, this one-liner would read something like
# if the exit code of the last command (ls in this example) was 0:
#     echo "File information: $contents"
# else:
#     echo "Error reading the file..."
test $? -eq 0 && echo "File information: $contents" || echo "Error reading the file..."
