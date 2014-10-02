#!/bin/sh

# Handles file names with spaces
find . -print0 | xargs -0 grep $* -sl;

