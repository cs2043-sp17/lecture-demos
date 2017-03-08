# Working with Files and Streams

This demo contains the files `numbers.txt` and `peeps.txt` used in the samples described
in the lecture slides.

The remainder of this document gives clarifications on working with `STDOUT` and
`STDERR`, and why the distinction is worth utilizing in scripts.  The script
`mixed_messages.sh` described at the end is also available here.

1. [Writing to Files](#writing-to-files)
2. [Printing Error Messages](#printing-error-messages)

## Writing to Files

In the most basic form, you have two options for writing to files.

1. Overwrite the entire file with a single `>`:

   ```bash
   # Create alchemy.haxor, *or* overwrite if it exists
   $ echo "This is filechemy at its finest." > alchemy.haxor
   ```

   Now print out the file to see what is there:

   ```console
   $ cat alchemy.haxor
   This is filechemy at its finest.
   ```

2. You will invariably need to append for this assignment, done with two `>>`.

   ```bash
   # Append a line to the same file.
   $ echo "The above line was only the beginning." >> alchemy.haxor
   ```

   Because we appended to the same file, we now have two lines:

   ```console
   $ cat alchemy.haxor
   This is filechemy at its finest.
   The above line was only the beginning.
   ```

   Notice, though, that if we append to a file that is not here, it creates the file

   ```bash
   # Create the file using append
   $ echo 'This is supreme ultra gangstarr hacking.' >> super_extreme.haxor_elite
   ```

   And confirm again to see that we do have the file

   ```console
   $ cat super_extreme.haxor_elite
   This is supreme ultra gangstarr hacking.
   ```

## Printing Error Messages

We have the ability to redirect to _streams_ as well as files from our shell.  We have
learned `echo` and `printf` (among others), but have generally only been printing to
`STDOUT` (which is stream `1`).  When printing error messages, it is good practice to
print error messages to `STDERR` (which is stream `2`).

1. Printing to `STDOUT`:

   ```bash
   # Implicit (the usual practice)
   $ echo "This is an output message."

   # Explicit (nobody does this, but you could)
   $ echo "This is an output message." >&1
   ```

   This says redirect (`>`) to the location / address of (`&`) stream `1`.

2. Printing to `STDERR`:

   ```bash
   $ echo "This is an error message." >&2
   ```

That's all there is to it!  There are many scenarios in which you want to print a
non-critical error message to inform the caller of your script, but still continue.  The
following example is rather contrived, but the idea is that if there was something that
went wrong or a warning should be issued, but we are still able to continue forward
**without** `exit`ing the script, we print these messages to `STDERR`.  Consider the
script `mixed_messages.sh`:

```bash
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
```

With this script, examine the difference (`cat` the files between executing each one):

```bash
# Run the script as is without any redirection
$ ./mixed_messages.sh

# We only redirect STDOUT to a file, STDERR still to console
$ ./mixed_messages.sh > just_stdout.txt

# Send STDOUT and STDERR to different locations (VERY USEFUL!)
$ ./mixed_messages.sh > just_stdout.txt 2> just_stderr.txt

# Send both to same file.  Often times people do this
# starting with >/dev/null instead of a file to ignore
# all output of a file
$ ./mixed_messages.sh > all_output.txt 2>&1

# If `bash --version` reports >= 4.0, there is a shortcut
# Inadvisable for scripts, but useful for your terminal
$ ./mixed_messages.sh &> all_output.txt
```

That is, if you are **good** you print error messages to STDERR so that users of your
scripts can use the redirections they know and love to distinguish error messages.
