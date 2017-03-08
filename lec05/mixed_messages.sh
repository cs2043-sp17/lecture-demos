#!/usr/bin/env bash

# Define a variable, recall we can only "expand" the value
# inside of "double quotes"!
msg="Script [$0] says:"

# Recall that special characters are worth being cautious about.
# Some special characters in this script are used, type `man bash`, hit the
# `/` key, type `  Special` (two spaces, capital S special), hit enter

# Notes:
# - String concatenation is easy!
# - Single quotes because of the exclamation point ;)
echo "$msg "'I AM ALIVE!'

# Print an error message if we cannot read this file
# (e.g. it does not exist).
if ! [[ -r some_file_not_here ]]; then
    echo "$msg I could not find the file." >&2
fi

# Print another message to STDOUT; single quote the question mark
echo "$msg curious, can a 'script' be 'alive'"'?'

# Print another message to STDERR
echo "$msg tautological dilemma caught, goodbye." >&2
