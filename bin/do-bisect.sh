#! /bin/bash

# perform git bisect on a repo with given script between 2 commits

set -euxo pipefail

REPO_ROOT="${1}"
GOOD="${2}"
BAD="${3}"
CHECKER_SCRIPT="${4}"

pushd "${PWD}"

cd "${REPO_ROOT}"

are_there_changes() {
	return $( git diff-index --quiet HEAD --)
}

#TODO modify this area
#if [[ ! "git diff-index --quiet HEAD --" ]]; then
#	echo "Uncomitted changes present."
#	exit 1
#fi

# add validation to make sure the test script runs well in good and fails in  bad commits

git bisect start
git bisect good "${GOOD}"
git bisect bad "${BAD}"
git bisect run "${CHECKER_SCRIPT}"
git bisect reset


exit 0
