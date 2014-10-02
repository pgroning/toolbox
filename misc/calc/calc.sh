#!/bin/bash

# Command line calculator built on bc

usage()
{
cat << EOF
usage: calc <OPTIONS>

calc is a terminal calculator.

OPTIONS:
   -h      Show this help message
   -f      List function library
   -e      Mathematical expression
   -d      Number of significant digits in output

Examples:
 $ calc -e 3+4
7

 $ calc -e pi*1e-2
0.031416

 $ calc -e "atan(1)*4" -d 16
3.141592653589793

EOF

}

listfuns()
{
cat << EOF
EOF
head -77 /home/prog/dvlp/scripts/calc/extensions.bc
}

if [ $# -le "0" ]; then
    usage
    exit 1
else

expr=
lib=
prec=
while getopts “hfe:d:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             listfuns
             exit 1
	     ;;
	 e)
             expr=$OPTARG
             ;;
	 d)
             prec=$OPTARG
             ;;
	 ?)
             usage
             exit
             ;;
     esac
done

fi

#if [[ -z $expr ]] && [[ -z $prec ]]; then # No arguments are given
#    usage
#    expr=$1
#    exit 1
#fi


expr=${expr//[eE]/*10^} # Handles scientific notation (e.g. 1E3)
expr=${expr//\*10\^xp/exp}

if [ -z $prec ]; then
    prec=5  # Default number of significant digits
fi

#if [[ -z $ibase ]]; then
#    ibase=10
#fi
#if [[ -z $obase ]]; then
#    obase=10
#fi

#result=`echo "scale=$prec+2;ibase=$ibase;obase=$obase; $expr" | bc -l /home/prog/dvlp/scripts/calc/extensions.bc`

result=`echo "scale=17; $expr" | bc -l /home/prog/dvlp/scripts/calc/extensions.bc`

#echo $result

if [ $prec -le "16" ]; then
    printf %.$prec\g\\n $result
else
    echo "Number of significant digits is limited to 16"
fi

