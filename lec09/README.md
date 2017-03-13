# Conditional Statements and Loops

This demo provides some examples of the do's and do not's for bash scripting conditional
statements and loops.

1. [Contrived](contrived) examples for conditional statements.
    - The moral: **always** save the exit code `$?` before doing comparisons.
    - Not always necessary, but will never hurt you.
2. [Simple](simple) examples of how to use script inputs.
    - There is a huge difference between the `$*` and `$@` input variables in scripts!
3. [Loops](loops) in the context of processing files.
    - Warnings about POSIX compliant files.
    - How to be able to handle all files, even if they are not POSIX compliant.
