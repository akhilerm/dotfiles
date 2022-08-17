#! /bin/bash


if [ -z GO_VERSION ]; then
	echo "get the latest version of golang from https://go.dev/dl/ as GO_VERSION=go1.18.2"
fi

if [ -z PROTOC_VERSION ]; then
	echo "get the latest protobuf version from https://github.com/protocolbuffers/protobuf/releases/latesti as PROTOC_VERSION=3.20.0"

# update and upgrade all the packages
sudo apt-get install update -y && sudo apt-get upgrade -y

# install git and build essential for initial setup and basic utilties
sudo apt-get install git build-essential vim unzip jq

# setup initial directories
mkdir bin
mkdir Work
mkdir go

# setup file for secrets via env
touch .env

cd Work
# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/configs.git

cd ~
ln -s Work/configs/.bashrc .bashrc
ln -s Work/configs/.bash_aliases .bash_aliases
ln -s Work/configs/.gitconfig .gitconfig

#install golang
wget https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz

#install protobuf
PB_REL="https://github.com/protocolbuffers/protobuf/releases"
curl -LO $PB_REL/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d $HOME/.local


# source the rc files
source ~/.bashrc

#remove the downloded archives
rm ${GO_VERSION}.linux-amd64.tar.gz
rm protoc-${PROTOC_VERSION}-linux-x86_64.zip
