#! /bin/bash

# this script creates symlinks for the binaries present in the provided path
# to the ~/bin directory. By default the binaries will be named as <binary>-dev
# If needed without the -dev suffix, pass prod as second argument to the script
# Usage
# $ symlink-bin build/bin/
# $ symlink-bin build/bin/ prod

DEV_BINARY_PATH=$1
DEV_SUFFIX="-dev"
if ! [ -z "$2" ] && [ "$2" = "prod" ]; then
	DEV_SUFFIX=""
fi

for binary in $(find "${DEV_BINARY_PATH}" -type f -executable -printf "%f\n");do
	# remove existing devlinks before creating new
	BINARY_NAME=$binary${DEV_SUFFIX}
	rm ~/bin/$BINARY_NAME || true
	ln -s "$PWD/$DEV_BINARY_PATH/$binary" ~/bin/$BINARY_NAME
done
