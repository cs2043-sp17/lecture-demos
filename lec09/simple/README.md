# Script Inputs Explained

## [`expansion.sh`](expansion.sh)

This file demonstrates the key difference between `$*` and `$@`.

- `$*` globs all inputs `$1..$n` into a **single** string.
- `$@` presents all inputs `$1..$n` **separately**.

```console
$ ./expansion.sh one two three four five
This is the *:
Var: one two three four five

This is the @:
Var: one
Var: two
Var: three
Var: four
Var: five
```

## [`multiply.sh`](multiply.sh)

This script demonstrates how to check the number of arguments given to the script using
the `$#` variable.  In this script we seek to simply compute the first input times the
second input.  We perform no error checking to make sure the inputs are numbers, for
simplicity.

If we detect that the number of arguments given are is **not 2**, we fail out printing
a message to inform the user how to use the script.  The error message also shows us
how to provide the name of the script using `$0`.

Lastly, recall that in arithmetic mode `(( double parentheses ))` we can usually get
away with not actually using the `$` for variable names.  For example

```bash
x=2
y=3

echo $(( x * y ))
```

However, in this case we **must** use the `$1` and `$2` -- if we didn't, it would just
perform `1 * 2`.

Example runs of the script:

```console
$ ./multiply.sh
Usage: ./multiply.sh num1 num2
$ ./multiply.sh 2 3
6
$ ./multiply.sh 2 3 4
Usage: ./multiply.sh num1 num2
```

## [`toLower.sh`](toLower.sh)

This file seeks two inputs: the input file and the output file.  The result will be to
translate all upper case letters from the input file into lower case letters in the
output file.

This script performs the same error processing, but also demonstrates how to verify that
the input file we need exists.  In this file, we will **always** overwrite the output
file if it exists.  Additionally, we demonstrate what we must do to accommodate for when
the input file and the output file are the same thing.  Namely, where piping and
redirection are concerned, if the input is the same as the output **the file will be
zeroed out**.

As an exercise, figure out how to run this script.  It's worth noting that in the case
where we need to make a temporary file, I have done something that is generally bad
practice.  Refer to the `man mktemp` page, this demo does not use it because it does not
always exist on every platform.

Alternatively, try using the existing approach, but before using it check that the file
does not exist first (e.g. go make it yourself).  In this instance, you would need to
write some sort of `while` loop and keep changing the name of the temporary file until
you have something that you can work with.

The best approach would probably be to use a `while` loop and `$RANDOM`.  Something like

```bash
# Try first
tmp_file="/tmp/to_lower_$RANDOM.txt"
# continue renaming the file while it *does* exist
while [[ -f "$tmp_file" ]]; do tmp_file="/tmp/to_lower_$RANDOM.txt"; done
# continue on as normal
```

The only other piece of information is using the `/tmp` directory.  This is a good idea
because if you forget to delete it (e.g. your script got killed), the operating system
will eventually perform its own maintenance and delete files not being used in `/tmp`.
