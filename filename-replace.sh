#!/bin/sh

set -e

find $1 -type f | while read line; do
  OLD_NAME="$line"

  # replacements:
  # " - " => "___"
  # " " => "-"
  NEW_NAME=`echo $line | sed "s/\ -\ /___/g" | sed "s/\ /-/g"`
  mv "$OLD_NAME" "$NEW_NAME"
done
