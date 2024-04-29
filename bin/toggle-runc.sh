#! /bin/bash

# both runc and crun should be available in the directory with
# runc.bin and crun.bin. runc will be a symlink to either of these
# binary

runc_path=$(which runc)
runc_dir=$(dirname $runc_path)

echo $(readlink -f $runc_path) | grep -q runc
IS_RUNC=$?

if [[ "$IS_RUNC" -eq 0 ]]; then
	sudo rm $runc_path
	sudo ln -s $runc_dir/crun.bin $runc_path
	echo "Switched to crun"
else
	sudo rm $runc_path
	sudo ln -s $runc_dir/runc.bin $runc_path
	echo "Swithced to runc"
fi

