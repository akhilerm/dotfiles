#! /bin/bash

# this script creates symlinks for the binaries present in the provided path
# to the ~/bin directory. By default the binaries will be named as <binary>-dev
# If needed without the -dev suffix, pass prod as second argument to the script
# Usage
# $ symlink-bin build/bin/
# $ symlink-bin build/bin/ prod

make_symlink() {
	binary=$1
	binary_path=$2
	suffix=$3
	binary_name=$binary${suffix}
	rm ~/bin/binary_name 2>/dev/null || true
	ln -s "$PWD/${binary_path}/$binary" ~/bin/$binary_name
}


DEV_BINARY_PATH=$1
DEV_SUFFIX="-dev"
if ! [ -z "$2" ] && [ "$2" = "prod" ]; then
	DEV_SUFFIX=""
fi

if [[ -f ${DEV_BINARY_PATH} ]]; then
	if [[ -x ${DEV_BINARY_PATH} ]]; then
		make_symlink ${DEV_BINARY_PATH} "" ${DEV_SUFFIX}
		exit 0
	fi
	exit 1
fi

for binary in $(find "${DEV_BINARY_PATH}" -type f -executable -printf "%f\n");do
	make_symlink $binary ${DEV_BINARY_PATH} ${DEV_SUFFIX}
done
