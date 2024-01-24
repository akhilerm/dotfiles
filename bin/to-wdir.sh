#!/bin/bash

# apply the git work config to the given git directory or current if nothing specifiec

if [ "$#" -ne 0 ]; then
  DIR="${1}"
else
  DIR="."
fi

pushd "${DIR}"

cat ~/.gitconfig-work >> .git/config

popd
