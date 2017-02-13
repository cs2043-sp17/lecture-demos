#!/usr/bin/env bash

# Make sure we have two arguments to multiply
if [[ $# -ne 2 ]]; then
    # It is generally good practice to print
    # error messages to stderr (stream 2).
    echo "Usage: $0 num1 num2" >&2
    exit 1
fi

# We can now use $1 and $2; we'll skip
# validating they are actually numbers for now
# Notice in this case we *must* use the $ for
# variable names even though we are in an
# arithmetic expression.
echo $(( $1 * $2 ))
# no exit call?  Default is exit 0 aka success
