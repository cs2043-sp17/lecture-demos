#!/usr/bin/env bash

# We need the input file, and the output file
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 input_file output_file" >&2
    exit 1
fi

# We need the input file to do anything...
# ...blindly overwrite output file if it exists
if ! [[ -f "$1" ]]; then
    echo "The input file [$1] does not exist..." >&2
    exit 1
fi

# If they are the same, you need to make a temp file!
if [[ "$1" != "$2" ]]; then
    tr '[A-Z]' '[a-z]' < "$1" > "$2"
else
    tmp_file="/tmp/very_unlikely_filename_ya"
    tr '[A-Z]' '[a-z]' < "$1" > "$tmp_file"
    cat "$tmp_file" > "$2"
    rm -f "$tmp_file"
fi
