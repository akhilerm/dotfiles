#! /bin/bash

set -e

# script should be run as non sudo. FOr commands requiring sudo the permission will 
# be asked inbetween

if [ -z GO_VERSION ]; then
	echo "get the latest version of golang from https://go.dev/dl/ as GO_VERSION=go1.18.2"
	exit 1
fi

if [ -z PROTOC_VERSION ]; then
	echo "get the latest protobuf version from https://github.com/protocolbuffers/protobuf/releases/latest as PROTOC_VERSION=20.0"
	exit 1
fi

# update and upgrade all the packages
sudo apt-get update -y && sudo apt-get upgrade -y

# install git and build essential for initial setup and basic utilties
sudo apt-get install git build-essential vim unzip jq curl \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    wget

# setup initial directories
mkdir bin
mkdir Work
mkdir go

# setup file for secrets via env
touch .env

cd Work
# initial cloning will be from https based since ssh keys are not yet present
git clone https://github.com/akhilerm/configs.git

# setup bash 
cd ~
rm .bashrc || true
ln -s ~/Work/configs/bashrc .bashrc

rm .bash_aliases || true
ln -s ~/Work/configs/bash_aliases .bash_aliases

rm .gitconfig || true
# gitconfig is copied since it can contain signing keys
cp Work/configs/gitconfig .gitconfig

#setup vim
rm .vimrc || tru
ln -s Work/configs/vimrc .vimrc

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

#install golang
wget https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz
sudo mv /usr/local/go /usr/local/${GO_VERSION}
sudo ln -s /usr/local/${GO_VERSION} /usr/local/go

#install protobuf
PB_REL="https://github.com/protocolbuffers/protobuf/releases"
curl -LO $PB_REL/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
sudo unzip -o  protoc-${PROTOC_VERSION}-linux-x86_64.zip -d "/usr/local" /bin/protoc
sudo unzip -o  protoc-${PROTOC_VERSION}-linux-x86_64.zip -d "/usr/local" 'include/*'


# source the rc files
source ~/.bashrc

#remove the downloded archives
rm ${GO_VERSION}.linux-amd64.tar.gz
rm protoc-${PROTOC_VERSION}-linux-x86_64.zip

#setup golang directories
mkdir ~/go/bin ~/go/pkg ~/go/src
ln -s ~/go/src ~/Work/Golang

#setup k8s directories
mkdir -p ~/go/src/github.com/kubernetes
mkdir -p ~/go/src/github.com/kubernetes-sigs
ln -s ~/go/src/github.com/kubernetes ~/go/src/k8s.io
ln -s ~/go/src/github.com/kubernetes-sigs ~/go/src/sigs.k8s.io

mkdir ~/go/src/github.com/akhilerm

#install docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

#install kubectl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

#install gcloud cli
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update -y && sudo apt-get install -y google-cloud-cli

# install trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install -y trivy

# install speedtest
sudo apt-get install speedtest-cli

# install github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# install dev libraries
sudo apt-get install -y libbtrfs-dev libfuse2

#install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text

#install openssh server
sudo apt-get install -y openssh-server

# Further instructions
echo "Generate GPG key, add it to github, add it to git config, add it to keychain"
echo "Generate SSH key, add it to github"
echo "gcloud init"
