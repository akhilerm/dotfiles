#! /bin/bash

set -euxo pipefail

# script should be run as non sudo. FOr commands requiring sudo the permission will
# be asked in between

# setup initial directories
mkdir bin
mkdir Work

pushd Work

# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/dotfiles.git
cd dotfiles
git remote set-url origin git@github.com:akhilerm/dotfiles.git

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#install omz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# back home
cd ~

# setup zsh configs
rm .zshrc || true
ln -s ~/Work/dotfiles/configs/zshrc .zshrc

# bash aliases will be used by zsh for aliasing in mac
rm .bash_aliases || true
ln -s ~/Work/dotfiles/configs/bash_aliases .aliases

# setup git config
rm .gitconfig || true
ln -s ~/Work/dotfiles/configs/gitconfig .gitconfig

# setup git config for work
rm .gitconfig-work || true
ln -s ~/Work/dotfiles/configs/gitconfig-work .gitconfig-work

# setup file for secrets via env
rm .env || true
ln -s ~/Work/dotfiles/env .env

#setup vim
rm .vimrc || true
ln -s Work/dotfiles/configs/vimrc .vimrc

#setup gpg config
mkdir .gnupg || true
echo "enable-ssh-support" >> .gnupg/gpg-agent.conf

# enable touch ID for sudo
sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
sudo sed -i -e 's/#auth/auth/g' /etc/pam.d/sudo_local

pushd ~/Work/dotfiles
# install brew packages
brew bundle install --file ./packages/brew/Brewfile

# script to install packages from common scripts
PACKAGE_DIRECTORY="./packages"
pushd "${PACKAGE_DIRECTORY}"
find * -maxdepth 0 -type f | while IFS= read -r file; do
  "./$file"
done
popd
popd

# copy the scripts and binaries
for script_file in ~/Work/dotfiles/bin/*; do
  # symlink all scripts except setup scripts
  script_file="${script_file##*/}"
	# remove the .sh extension while creating symlink
  ln -s ~/Work/dotfiles/bin/$script_file ~/bin/$(basename $script_file .sh)
done

# source the rc files
source ~/.zshrc

# ghostty config
ln -s ~/Work/dotfiles/configs/ghostty-config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
ln -s ~/Work/dotfiles/configs/ghostty-config-mac "$HOME/Library/Application Support/com.mitchellh.ghostty/config-mac"

#setup default text editor
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.4;}'

# remove conflicting man page and intellij shortcut
TEMP_SETTINGS_FILE=$(mktemp -t 'man-shortcuts-off.json')
cat > $TEMP_SETTINGS_FILE <<EOF
{
  "NSServicesStatus": {
    "com.apple.Terminal - Open man Page in Terminal - openManPage": {
      "presentation_modes": {
        "ContextMenu": false,
        "ServicesMenu": false
      },
      "enabled_context_menu": false,
      "enabled_services_menu": false
    },
    "com.apple.Terminal - Search man Page Index in Terminal - searchManPages": {
      "presentation_modes": {
        "ContextMenu": false,
        "ServicesMenu": false
      },
      "enabled_context_menu": false,
      "enabled_services_menu": false
    }
  }
}
EOF
# Settings are stored in the pbs domain. Other settings in this domain will not be overwritten. I’ve included the settings to change in JSON for brevity. They are converted to XML (which `defaults import` expects) before being imported.
plutil -convert xml1 -o - ${TEMP_SETTINGS_FILE} | defaults import pbs -
rm ${TEMP_SETTINGS_FILE}

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
echo "Run 'gh auth login' to login to GitHub"
echo "Run 'gpg -K --with-keygrip' and add the authentication key to ~/.gnupg/sshcontrol"
