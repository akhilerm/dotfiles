#! /bin/bash


# script should be run as non sudo. FOr commands requiring sudo the permission will 
# be asked inbetween

if [ -z GO_VERSION ]; then
	echo "get the latest version of golang from https://go.dev/dl/ as GO_VERSION=go1.18.2"
fi

if [ -z PROTOC_VERSION ]; then
	echo "get the latest protobuf version from https://github.com/protocolbuffers/protobuf/releases/latest as PROTOC_VERSION=20.0"
fi

# update and upgrade all the packages
sudo apt-get update -y && sudo apt-get upgrade -y

# install git and build essential for initial setup and basic utilties
sudo apt-get install git build-essential vim unzip jq curl

# setup initial directories
mkdir bin
mkdir Work
mkdir go
# setup symlink for gopath
ln -s ~/go ~/Work/go

# setup file for secrets via env
touch .env

cd Work
# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/configs.git

# setup bash 
cd ~
rm .bashrc
ln -s ~/Work/configs/.bashrc .bashrc

rm .bash_aliases
ln -s ~/Work/configs/.bash_aliases .bash_aliases

rm .gitconfig
ln -s ~/Work/configs/.gitconfig .gitconfig

# copy the scripts and binaries
for script_file in ~/Work/configs/bin/*; do
        # symlink all scripts except ubuntu setup
        script_file="${script_file##*/}"
        if [ "$script_file" = "ubuntu_setup.sh" ]; then
                continue
        fi
        ln -s ~/Work/configs/bin/$script_file ~/bin/$script_file
done

#install golang
wget https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz
sudo mv /usr/local/go /usr/local/${GO_VERSION}
sudo ln -s /usr/local/${GO_VERSION} /usr/local/go

#install protobuf
PB_REL="https://github.com/protocolbuffers/protobuf/releases"
curl -LO $PB_REL/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d $HOME/.local


# source the rc files
source ~/.bashrc

#remove the downloded archives
rm ${GO_VERSION}.linux-amd64.tar.gz
rm protoc-${PROTOC_VERSION}-linux-x86_64.zip
