#!/usr/bin/env bash

# Part 1: put your name in the brackets [here]
# This will let us examine what `git diff` looks like.

# Make sure that we are in a git repository.
git rev-parse --show-toplevel >/dev/null 2>&1
if [[ "$?" -ne 0 ]]; then
    # This is a "multi-line string" in bash.  Note the care taken with white-space.
    msg='[x] You are not in a git repository, and seem to be trying to cheat the system.
    You can execute

        \033[7mgit rev-parse --show-toplevel\033[27m

    to verify that you are in a valid git repository.'
    # -e lets us use the escape sequence in the string
    echo -e "$msg"
    exit 1
fi

# Get the git branch
branch="$(git branch)"
echo "The branch you are on: $branch"
