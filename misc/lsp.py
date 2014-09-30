#!/usr/bin/env python

## import libs
import sys, os, getopt

## Check python interpreter version
try:
    cur_ver = sys.version_info #Current version
except:
    ver_message="Your python interpreter is too old. Sorry!"
    print ver_message
    sys.exit(2)

## Exit message
try:
    ver_message = "Error: Your python interpreter is too old. \
    Your current version is {0}.{1}.{2}."\
    .format(cur_ver[0],cur_ver[1],cur_ver[2])
except: #For old python versions
    try:
        ver_message = "Error: Your python interpreter is too old. \
Your current version is "
        ver_message=ver_message+"%s."%cur_ver[0]+"%s."%cur_ver[1]+"%s."%cur_ver[2]
    except:  #For even older python versions
        ver_message="Your python interpreter is too old. Sorry!"

## Print help
def usage():
    print "Usage: lsp [Options]... [FILE]...\n\
List FILEs (the current directory by default) with absolute or relative \
paths.\n\
The FILEs are listed in alphabetical order.\n\n\
Options:\n\
 -h, --help      : show this help message and exit\n\
 -d, --directory : starting-point for relative paths (defult current directory)"
    return

## Check input from command line
argv = sys.argv[1:] #input arguments
startpoint = os.curdir; #Set default to current directory
print_relpath = 0
try:                                
    optlist, args = getopt.gnu_getopt(argv, "hd:", ["help", "directory="])
except getopt.GetoptError, err:
    print str(err); #Print error msg
    print "type 'lsp --help' for more information"
    sys.exit(2)

for opt, arg in optlist:
    if opt in ("-h", "--help"):
        usage()
        sys.exit()
    elif opt in ("-d", "--directory"):
        startpoint = arg
        print_relpath = 1

if (len(args) < 1):
    args.append(os.curdir) #List current directory

if (os.path.isdir(startpoint)==0):
    try:
        print "'{}' is not a directory".format(startpoint)
    except: #Code for older python versions
        print "'%s' is not a directory"%startpoint
        sys.exit(2)

if (os.path.isdir(args[0])): #Argument is a directory
    path = args[0]
    abspath = os.path.abspath(path)
    dirList=os.listdir(path)
    dirList.sort()
    for fname in dirList:
        absfile = os.path.join(abspath,fname)
        if (os.path.isabs(path) or print_relpath):
            try:
                print os.path.relpath(absfile, startpoint)
            except: #Python version is too old
                print ver_message
                sys.exit(2)
        else:
            print absfile
else: #Argument is a file
    for fname in args:
        if (os.path.exists(fname)):
            if (os.path.isabs(fname) or print_relpath):
                try:
                    print os.path.relpath(fname, startpoint)
                except: #Python version is too old
                    print ver_message
                    sys.exit(2)
            else:
                print os.path.abspath(fname)
        else:
            try:
                print "lsp: cannot access '{}': No such file or directory".format(fname)
            except: #Code for older python versions
                print "lsp: cannot access '%s': No such file or directory"%fname
                sys.exit(2)
