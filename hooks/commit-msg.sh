#!/bin/sh
 
if grep -E '\#[0-9]+' "$1" > /dev/null; then
  exit 0
fi
 
echo
echo \!COMMIT ABORTED\! MISSING GITHUB ISSUE NUMBER\!
echo Make sure you add \[\#number\] to your commit message.
echo
 
exit 1