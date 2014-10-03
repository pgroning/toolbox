#!/bin/sh

# List files above a certain limit in size
# SYNTAX:
# List all files above 300 kB in size
# findlf.sh 300k 
# List all files above 300 MB in size
# findlf.sh 3M

find . -type f -size +$* -exec ls -lh {} \; 2>/dev/null | awk '{ print $5 " : " $9}'
