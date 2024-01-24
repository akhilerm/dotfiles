#! /bin/bash

set -euxo pipefail

# script should be run as non sudo. FOr commands requiring sudo the permission will
# be asked inbetween

# update and upgrade all the default_packages
sudo apt-get update -y && sudo apt-get upgrade -y

# setup initial directories
mkdir bin
mkdir Work

pushd Work
# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/configs.git
cd configs
git remote --set-url origin git@github.com:akhilerm/configs.git

## script to install default packages
DEFAULT_PACKAGES_FILE="./packages/default_packages"
DEFAULT_PACKAGES=""
while IFS= read -r package; do
  # Skip empty lines or lines starting with #
  if [[ -z "$package" || "$package" == "#"* ]]; then
    continue
  fi
  DEFAULT_PACKAGES="${DEFAULT_PACKAGES} $package"
done < "${DEFAULT_PACKAGES_FILE}"

sudo apt-get install -y "${DEFAULT_PACKAGES}"

## script to install other packages/binaries
PACKAGE_DIRECTORY="./packages"
pushd "${PACKAGE_DIRECTORY}"
for file in *; do
  if [ "$file" == "default_packages" ]; then
    continue
  fi

  "./$file"
done
popd

# back to home directory
popd

# setup bash configs
rm .bashrc || true
ln -s ~/Work/configs/bashrc .bashrc

rm .bash_aliases || true
ln -s ~/Work/configs/bash_aliases .bash_aliases

# setup git config
rm .gitconfig || true
ln -s ~/Work/configs/gitconfig .gitconfig

# setup file for secrets via env
rm .env || true
ln -s ~/Work/configs/env .env

#setup vim
rm .vimrc || true
ln -s Work/configs/vimrc .vimrc

#setup gpg config
mkdir .gnupg || true
echo "enable-ssh-support" >> .gnupg/gpg-agent.conf

# copy the scripts and binaries
for script_file in ~/Work/configs/bin/*; do
  # symlink all scripts except ubuntu setup
  script_file="${script_file##*/}"
  if [ "$script_file" = "ubuntu_setup.sh" ]; then
    continue
  fi
	# remove the .sh extension while creating symlink
  ln -s ~/Work/configs/bin/$script_file ~/bin/$(basename $script_file .sh)
done

# source the rc files
source ~/.bashrc


#setup golang directories
mkdir go
mkdir ~/go/bin ~/go/pkg ~/go/src
ln -s ~/go/src ~/Work/Golang

#setup k8s directories
mkdir -p ~/go/src/github.com/kubernetes
mkdir -p ~/go/src/github.com/kubernetes-sigs
ln -s ~/go/src/github.com/kubernetes ~/go/src/k8s.io
ln -s ~/go/src/github.com/kubernetes-sigs ~/go/src/sigs.k8s.io

mkdir ~/go/src/github.com/akhilerm

# Further instructions
echo "Additional steps to be completed"
echo "Run 'gcloud init' to login to gcloud from cli"
echo "Run 'gpg -K --with-keygrip' and add the authentication key to ~/.gnupg/sshcontrol"