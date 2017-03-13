#!/usr/bin/env bash

# Assume that there is a file as input in $1
# save results, ignore stderr
contents="$(ls -al "$1" 2>/dev/null)"

# See the explanation in `test.sh` for what this evaluates as,
# it is exactly the same thing only we are calling `test $? -eq 0`
# implicitly using the [[ $? -eq 0 ]] notation.
#
# Again, I personally believe this notation causes more confusion
# than it does provide clarity, but it exists and you can always
# use it if you like, as well as you will want to understand it.
[[ $? -eq 0 ]] && echo "File information: $contents" || echo "Error reading the file..."
