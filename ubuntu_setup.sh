#! /bin/bash

set -euxo pipefail

# script should be run as non sudo. FOr commands requiring sudo the permission will
# be asked inbetween

# update and upgrade all the default_packages
sudo apt-get update -y && sudo apt-get upgrade -y
# installing git here because we need it for cloning the complete repository
sudo apt-get install git -y

# setup initial directories
mkdir bin
mkdir Work

pushd Work
# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/dotfiles.git
cd dotfiles
git remote set-url origin git@github.com:akhilerm/dotfiles.git

export DEBIAN_FRONTEND=noninteractive

## script to install default packages
DEFAULT_PACKAGES_FILE="./packages/apt/default_packages"
DEFAULT_PACKAGES=()
# remove too much verbosity
set +x
while IFS= read -r package; do
  # Skip empty lines or lines starting with #
  if [[ -z "$package" || "$package" == "#"* ]]; then
    continue
  fi
  DEFAULT_PACKAGES+=($package)

done < "${DEFAULT_PACKAGES_FILE}"
set -x

sudo apt-get install -y "${DEFAULT_PACKAGES[@]}"

# script to install packages from common scripts
PACKAGE_DIRECTORY="./packages"
pushd "${PACKAGE_DIRECTORY}"
find * -maxdepth 0 -type f | while IFS= read -r file; do
  "./$file"
done
popd

## script to install other packages/binaries
PACKAGE_DIRECTORY="./packages/apt"
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
ln -s ~/Work/dotfiles/bashrc .bashrc

rm .bash_aliases || true
ln -s ~/Work/dotfiles/bash_aliases .bash_aliases

# setup git config
rm .gitconfig || true
ln -s ~/Work/dotfiles/gitconfig .gitconfig
ln -s ~/Work/dotfiles/gitconfig-work .gitconfig-work
ln -s ~/Work/dotfiles/git-template .git-template

# setup file for secrets via env
rm .env || true
ln -s ~/Work/dotfiles/env .env

#setup vim
rm .vimrc || true
ln -s ~/Work/dotfiles/vimrc .vimrc
sudo update-alternatives --set editor /usr/bin/vim.basic

#setup ghostty
ln -s ~/Work/dotfiles/configs/ghostty-config ~/.config/ghostty/config
ln -s ~/Work/dotfiles/configs/ghostty-config-linux ~/.config/ghostty/config-linux

#setup gpg config
mkdir .gnupg || true
echo "enable-ssh-support" >> .gnupg/gpg-agent.conf
# sometimes in tmux setup pinentry-tty is needed for correct working
# sudo update-alternatives --set pinentry /usr/bin/pinentry-tty

# copy the scripts and binaries
for script_file in ~/Work/dotfiles/bin/*; do
  # symlink all scripts
  script_file="${script_file##*/}"
	# remove the .sh extension while creating symlink
  ln -s ~/Work/dotfiles/bin/$script_file ~/bin/$(basename $script_file .sh)
done

#setup golang directories
mkdir go
mkdir ~/go/bin ~/go/pkg ~/go/src
ln -s ~/go/src ~/Work/Golang

#setup k8s directories
mkdir -p ~/go/src/github.com/kubernetes
mkdir -p ~/go/src/github.com/kubernetes-sigs
ln -s ~/go/src/github.com/kubernetes ~/go/src/k8s.io
ln -s ~/go/src/github.com/kubernetes-sigs ~/go/src/sigs.k8s.io

#setup additional directories
mkdir ~/Work/dev-config.d
mkdir ~/go/src/github.com/akhilerm

# Further instructions
echo "Additional steps to be completed"
echo "Run 'gcloud init' to login to gcloud from cli"
echo "Run 'gpg --import <key-fil>' to import the key"
echo "Run 'gpg -K --with-keygrip' and add the authentication key to ~/.gnupg/sshcontrol"
echo "Run 'source ~/.bashrc'. This will switch to a tmux session if the machine is logged in via ssh"
