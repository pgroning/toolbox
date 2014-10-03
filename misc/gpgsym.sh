#!/bin/bash
# Symmetric encryption/decryption of files
# SYNTAX:
# Encryption:
# $ gpgsym.sh -e -p <passwd> <file>
# Decryption:
# $ gpgsym.sh -p <passwd> <file>.gpg

while getopts "aep:" opt; do
  case $opt in
    a)
      ASCII=true
      ;;
    e)
      ENCRYPT=true
      ;;
    p)
      PASSPHRASE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ -z "$PASSPHRASE" ]; then
    echo "A passphrase must be given"
    exit 1;
fi

FILE=$BASH_ARGV # Fetch last argument
if [ -z "$FILE" ]; then
    echo "A file must be given"
    exit 1;
fi

if [ "$ENCRYPT" = true ]; then # Encrypt file
    if [ "$ASCII" = true ]; then
        gpg2 --batch --yes --symmetric --cipher-algo AES256 --armor --passphrase $PASSPHRASE $FILE
    else
        gpg2 --batch --yes --symmetric --cipher-algo AES256 --passphrase $PASSPHRASE $FILE
    fi
    echo "$FILE was successfully encrypted"
else # Decrypt file
    gpg2 --batch --yes --passphrase $PASSPHRASE $FILE
fi
