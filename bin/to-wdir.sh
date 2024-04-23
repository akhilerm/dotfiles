#!/bin/bash

# apply the git work config to the given git directory or current if nothing specified

if [ "$#" -ne 0 ]; then
  DIR="${1}"
else
  DIR="."
fi

pushd "${DIR}"

git config --local include.path ~/.gitconfig-work

popd
