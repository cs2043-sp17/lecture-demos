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
