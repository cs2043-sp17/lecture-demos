#!/usr/bin/env bash

# note the use of single quotes to get a literal *
echo 'This is the *:'
for var in "$*"; do
    echo "Var: $var"
done

echo 'This is the @:'
for var in "$@"; do
    echo "Var: $var"
done
