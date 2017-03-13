# Looping through files

## POSIX compliance

Before we talk about the differences between `cat` and `read` in terms of going through
every line in a file, I need to mention what it means for a text file to be `POSIX`
compliant.  Some of you may had your C compiler complain because there was no empty line
at the bottom -- this is because not having that is a non-`POSIX` compliant file.
Effectively, there needs to be an extra newline (`\n`) character at the end.  Ensuring
that you have created a `POSIX` compliant file is not always so straight-forward, as how
to verify depends on your text editor.

The good news, though, is that your terminal can save the day here.  I cannot show you
how this works in Markdown, but can from terminal output.  Using the files
`lines_INVALID.txt` and `lines.txt`, we can easily see the difference if we use `cat`
from the terminal.  I am going to include the my full terminal output in this so that it
is a little clearer:

### Non-POSIX compliant demonstration

```console
sven:~/Desktop/lecture-demos/lec09> cat lines_INVALID.txt
0123456789
    0123456789
        0123456789
    0123456789
0123456789sven:~/Desktop/lecture-demos/lec09>
```

Notice how, since we don't have that trailing newline character, the prompt for the next
terminal command shows up **on the same line**.  Look at the next section and it will
become clear.

### POSIX compliant demonstration

```console
sven:~/Desktop/lecture-demos/lec09> cat lines.txt
0123456789
    0123456789
        0123456789
    0123456789
0123456789
sven:~/Desktop/lecture-demos/lec09>
```

The prompt showed up **on the next line** this time, indicating that our file had that
trailing newline.  I have deliberately given you `lines.txt` and `lines_INVALID.txt`
here because how we loop through files can be impacted by whether or not we are given
a POSIX compliant file.

## Using `cat` for looping through files

You may be thinking "Ok well that seems reliable", lets loop through every line in
`lines.txt` and see what happens when we use the `use_cat.sh` script.  For simplicity,
I will not validate input and assume that `"$1"` is the filename we want to loop through.

```bash
#!/usr/bin/env bash

for line in $(cat "$1"); do
    echo "$line"
done
```

which will give us the output:

```console
$ ./use_cat.sh lines.txt
0123456789
0123456789
0123456789
0123456789
0123456789
```

already we can start to see problems.  But before we fix the missing preceding
whitespace, lets be a little more clear on why `cat` is going to fail you even more than
that.  The file `cat_fail.txt` has the following lines:

```
This_line_works_because_it_has_no_spaces.
This    line    fails   because it  has tabs.
This line fails because it has spaces.
```

You can also execute `grep $'\t' cat_fail.txt` to verify the second line has tab
characters.  This gives me an excuse to show you "ANSI C Quoting", something you can use
in `bash` free of charge!  You can also use that to find newline characters, carriage
returns, and many other special characters.  Much more information [here](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html).

If we use `cat` to iterate through the lines, it will breakdown because it will see the
whitespace characters and split it for you:

```console
$ ./use_cat.sh cat_fail.txt
This_line_works_because_it_has_no_spaces.
This
line
fails
because
it
has
tabs.
This
line
fails
because
it
has
spaces.
```

## Using `read` for looping through files

The solution is to use the `read` command instead.  Lets start with the `read_naive.sh`
script (recall I am not doing error checking, we assume a filename is provided):

```bash
#!/usr/bin/env bash

while read line; do
    echo "Len [${#line}]: $line"
done < "$1"
```

So we will just go through and print out the length of every line and then the line
after it.  Using the `cat_fail.txt` file, we get

```console
$ ./read_naive.sh cat_fail.txt
Len [41]: This_line_works_because_it_has_no_spaces.
Len [36]: This  line    fails   because it  has tabs.
Len [38]: This line fails because it has spaces.
```

So immediately `read` is already beating `cat` in terms of handling whitespace on a line
such as tab and space characters.  But if we run it on the files that had preceding
whitespace, such as `lines.txt`, we will get:

```console
$ ./read_naive.sh lines.txt
Len [10]: 0123456789
Len [10]: 0123456789
Len [10]: 0123456789
Len [10]: 0123456789
Len [10]: 0123456789
```

This is because `read` uses the `IFS` variable of your shell as its `I`nternal `F`ield
`S`eparator, which defaults to be whitespace characters e.g. tabs and spaces.  Before
pointing you to extensive documentation on `$IFS`, lets finish the demo to see how to
fix things.  Lets make a `read_better.sh` script to account for this:

```bash
#!/usr/bin/env bash
#
# Warning: make sure IFS='' is on the **SAME** line as the
# `read` command.  This sets the IFS variable (Internal Field
# Separator) ONLY for that command.
#
# If you set this on its own line, you set it for the **REMAINDER**
# of the script, which will probably break everything you do.
while IFS='' read line; do
    echo "Len [${#line}]: $line"
done < "$1"
```

All we have to do is make the `IFS` variable the empty string **for the `read` command**,
and it won't trim our preceding whitespace:

```console
$ ./read_better.sh lines.txt
Len [10]: 0123456789
Len [14]:     0123456789
Len [18]:         0123456789
Len [14]:     0123456789
Len [10]: 0123456789
```

Unfortunately, though, when given a non-POSIX compliant file, this approach will still
have errors:

```console
$ ./read_better.sh lines_INVALID.txt
Len [10]: 0123456789
Len [14]:     0123456789
Len [18]:         0123456789
Len [14]:     0123456789
```

It missed the last line!  This is to be expected, and the official answer is "you should
not care, because the user gave you an invalid file".  However, if you really want to
support this, we just need to add one more little trick in: make sure that the string is
of non-zero length using the bash `-n` test.  This is in the script `read_even_INVALID.sh`:

```bash
#!/usr/bin/env bash
#
# Warning: make sure IFS='' is on the **SAME** line as the
# `read` command.  This sets the IFS variable (Internal Field
# Separator) ONLY for that command.
#
# If you set this on its own line, you set it for the **REMAINDER**
# of the script, which will probably break everything you do.
while IFS='' read line || [[ -n "$line" ]]; do
    echo "Len [${#line}]: $line"
done < "$1"
```

and now we can succeed on all files:

```console
$ ./read_even_INVALID.sh cat_fail.txt
Len [41]: This_line_works_because_it_has_no_spaces.
Len [36]: This  line    fails   because it  has tabs.
Len [38]: This line fails because it has spaces.
$ ./read_even_INVALID.sh lines.txt
Len [10]: 0123456789
Len [14]:     0123456789
Len [18]:         0123456789
Len [14]:     0123456789
Len [10]: 0123456789
$ ./read_even_INVALID.sh lines_INVALID.txt
Len [10]: 0123456789
Len [14]:     0123456789
Len [18]:         0123456789
Len [14]:     0123456789
Len [10]: 0123456789
```

## The Takeaway

Using `read` is advantageous because it is easier to control than `cat`.  Although you
can find workarounds for `cat`, it is generally a bad idea.  Other than having trouble
with whitespace, consider trying to parse a file that is ten million lines long (and
yes...this is definitely a real-world example).  If you use `cat` to store it in a
variable, then you are being extremely wasteful as well as your script very well may
crash because it could run out of memory.  `read` will not load the entire file at once,
and you can control how it treats separators, whitespace, etc.

You will not need to worry about me giving you non-POSIX compliant files in terms of
assignments, but it is definitely important that you understand that they can cause you
trouble, and you can write your scripts to account for them without much effort.  That
is, if you know how to write a more robust script, why not always do it?

## The `I`nternal `F`ield `S`eparator

Changing this in a script is a very advanced action, and in all honestly will usually
result in peril.  Just as saving the exit code `$?` is fundamentally important, if you
want to change the `$IFS` variable for a portion of your script, you damn sure better
save the original -- **and put it back**.

Almost every command you know **relies** on the `$IFS` variable.  So if you change it,
there is no telling what will happen unless you deliberately want to change the
behavior of the commands.

There is a long list of important [internal variables](http://tldp.org/LDP/abs/html/internalvariables.html),
for which `$IFS` is one of.  Search for `$IFS` on that page.  The `Example 9-1. $IFS and
whitespace` gives some examples of how to change it.  You could imagine this being
rather convenient if you want to change behavior of your shell / commands.  But I
reiterate that forgetting to change it back may break the rest of your script.

```bash

# Save the old IFS variable
OLD_IFS="$IFS"

# Set the new one, do your work
IFS=',' # or whatever, see above linked example 9-1
# ... do work ...

# Set it back!
IFS="$OLD_IFS"
# perform the rest of your actions as normal
```
