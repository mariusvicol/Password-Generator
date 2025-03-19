#!/bin/bash

PASSWORD_LENGTH=14

usage() {
  echo "Usage: $0 [-l length] [-u] [-n] [-s]"
  echo "  -l length  : Specify the length of the password (default: 12)"
  echo "  -u         : Include uppercase letters"
  echo "  -n         : Include numbers"
  echo "  -s         : Include special characters"
  exit 1
}

while getopts ":l:uns" opt; do
  case $opt in
    l)
      PASSWORD_LENGTH=$OPTARG
      if ! [[ "$PASSWORD_LENGTH" =~ ^[0-9]+$ ]]; then
        echo "Error: Password length must be a positive integer."
        exit 1
      fi
      ;;
    u)
      INCLUDE_UPPERCASE=true
      ;;
    n)
      INCLUDE_NUMBERS=true
      ;;
    s)
      INCLUDE_SPECIAL=true
      ;;
    *)
      usage
      ;;
  esac
done

CHAR_LOWER="abcdefghijklmnopqrstuvwxyz"
CHAR_UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
CHAR_NUMBER="0123456789"
CHAR_SPECIAL="!@#$%^&*()-_=+[]{};:,.<>?"

CHAR_SET=$CHAR_LOWER
if [ "$INCLUDE_UPPERCASE" = true ]; then
  CHAR_SET+=$CHAR_UPPER
fi
if [ "$INCLUDE_NUMBERS" = true ]; then
  CHAR_SET+=$CHAR_NUMBER
fi
if [ "$INCLUDE_SPECIAL" = true ]; then
  CHAR_SET+=$CHAR_SPECIAL
fi

if [ -z "$CHAR_SET" ]; then
  echo "Error: No character types selected for the password."
  exit 1
fi

PASSWORD=$(< /dev/urandom tr -dc "$CHAR_SET" | head -c "$PASSWORD_LENGTH")

echo "Generated Password: $PASSWORD"
