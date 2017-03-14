# Conditional Statements and Testing

There are closely related, but completely different examples present in the
[broken](broken) and [correct](correct) directories.  The examples roughly cover

1. Using `if` statements (`if.sh`).
2. Using `if` - `elif` statements (`elif.sh`).
    - You can also add an `else` as well!  Just make sure you always close with the `fi`.
3. Calling the `test` function directly (`test.sh`).
4. Using `[[ test expressions ]]` (`ugly_*.sh`).

## Purpose of the Scripts

The goal of these scripts is to show you the importance of, when doing error checking,
**always** saving the exit code variable `$?`.  Not doing so can produce unexpected
results that can be hard to find.

The reason the examples in the [broken](broken) directory do not work is because when
`if` statements are evaluated, they internally call the `test` command.  Since this is
it's own command, the `$?` variable is now overridden with the result of calling `test`!

## Running the Examples: Start with [Broken](broken)!

Each of the scripts is simply trying to print the contents of `ls filename`, where
`filename` is the input to the script.  For example, if you `cd broken/` and run the
`if.sh` program with a file that does exist (kind of cool, the script can use itself!):

```console
$ ./if.sh if.sh
File information: -rwxrwxr-x. 1 sven sven 384 Mar 13 05:35 if.sh
```

Works as expected.  Now if we run it with a file that does not exist:

```console
$ ./if.sh not_here_yo
Error reading the file...
File information:
```

**Oops!**  The expected output of all of these examples is supposed to be:

1. If we give it a file that exists: it simply prints the results of `ls -al` on that
   file with the string `File information:` at the front.
2. If we did **not** give a valid file, or we do not have permission to read the file,
   then it should _only_ print `Error reading the file...`.

In the above _broken_ execution, we received both messages.  The final line
`File information:` with nothing following it is hardly useful, since there was no
file to present information about.

In some of the examples, _too much_ gets printed.  In some of the examples, _nothing_
gets printed even when it should!  All of these results from just forgetting to save
the exit code in a variable.

## The Behavior is Unpredictable -- What do I do?

Look at the code for each example and accompanying comments in the file.  You will see
that the last line of output, `File information:`, is not what we intended to print.

Depending on how you are "testing" things -- `if` vs `test`, results vary.  Open up
the scripts and figure out what is going on.  Even more important, the _order_ in which
things are being executed is actually very important!  Try switching the order of the
`if` statements in `broken/if.sh`.  Eeek!

## Solutions

When you think you understand why they are broken, see if you can fix them.  The files
in the [correct](correct) directory have the solutions.
