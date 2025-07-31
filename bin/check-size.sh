#! /bin/bash

# script to list the sizes of various files and directories in a directory
# and sort them on size. hidden dirs/files not included now
# Usage:
# $ check-size -s M /home/akhil
# $ check-size /home/akhil
# $ check-size
#
while getopts ":s:" opt; do
  case $opt in
    s)
      size=$OPTARG
      ;;
    *)
      echo "Invalid flag -$OPTARG"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

dir="${1:-$PWD}"

sudo -v

sort -k1 -h <(sudo du -sh "$dir"/*) | awk -v size_short_char="$size" 'index($1, size_short_char) > 0 { print }'