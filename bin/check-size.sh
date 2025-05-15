#! /bin/bash

# script to list the sizes of various files and directories in a directory
# and sort them on size. hidden dirs/files not included now

dir="${1:-$PWD}"

sudo -v

sort -k1 -h <(sudo du -sh "$dir"/*)
