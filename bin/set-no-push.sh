#! /bin/bash

set -eo pipefail


# Set push URL of all remotes except *origin to no_push

git remote -v | grep -v origin | awk '{print $1}' | uniq | xargs -I '{}' git remote set-url '{}' --push no_push
