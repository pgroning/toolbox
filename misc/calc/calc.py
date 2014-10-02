#!/usr/bin/env python

## import libs
import sys, os, getopt
import subprocess as sub

#from subprocess import call

## Define usage function
def usage():
    print "Usage: calc [Expr]... [Options]...\n\
List FILEs (the current directory by default) with absolute or relative paths.\n\
The FILEs are listed in alphabetical order.\n\n\
Options:\n\
 -h, --help      : show this help message and exit\n\
 -p, --precision : number of decimals to display\n\
 -l, --library   : include custom library (.bc file)"
    return

## Check input from command line
argv = sys.argv[1:] #input arguments
try:                                
    optlist, args = getopt.gnu_getopt(argv, "hd:", ["help", "directory="])
except getopt.GetoptError, err:
    print str(err); #Print error msg
    print "type 'calc --help' for more information"
    sys.exit(2)
    
## Print help
for opt, arg in optlist:
    if opt in ("-h", "--help"):
        usage()
        sys.exit()

if (len(args) < 1): #Empty argument list
    usage()
    sys.exit()

## Open bc subprocess
cmd = 'ls -l'
p = sub.Popen(cmd, shell=True, stdout=sub.PIPE, stderr=sub.STDOUT)
output, errors = p.communicate()

print output

sys.exit(2)
