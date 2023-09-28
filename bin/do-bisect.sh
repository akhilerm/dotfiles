#! /bin/bash

# perform git bisect on a repo with given script between 2 commits

set -euxo pipefail


print_usage() {
	echo "do-bisect <REPO_ROOT> <GOOD_COMMIT> <BAD_COMMIT> <TEST_SCRIPT>"
}

if [ $# -ne 4 ]; then
	echo "Error: Missing or incorrect number of arguments."
	print_usage
        exit 1
fi

REPO_ROOT="${1}"
GOOD="${2}"
BAD="${3}"
CHECKER_SCRIPT="${4}"

pushd "${PWD}"

cd "${REPO_ROOT}"

# TODO add validation to check there are no uncommited changes
#are_there_changes() {
#	return $( git diff-index --quiet HEAD -- )
#}
#
## make sure that there are no uncommited changes
#if are_there_changes ; then
#	echo "Uncomitted changes present."
#	exit 1
#fi
#
# validate the script at $GOOD commit
git checkout "${GOOD}"
"${CHECKER_SCRIPT}" || true
rc=$?
if [[ $rc -ne 0 ]]; then
	echo "test script fails at good commit"
	exit 1
fi


# validate the script at $BAD commit
git checkout "${BAD}"
"${CHECKER_SCRIPT}" || true
rc=$?
if [[ $rc -eq 0 ]]; then
	echo "test script succeeded at bad commit"
	exit 1
fi

git bisect start
git bisect good "${GOOD}"
git bisect bad "${BAD}"
git bisect run "${CHECKER_SCRIPT}"
git bisect reset

exit 0
