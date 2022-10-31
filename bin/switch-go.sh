#! /bin/bash

# script to switch go version. If the version is not found, will try to 
# download it
# Usage
# switch-go.sh go1.18.3

GO_VERSION=$1
CURRENT_VERSION=$(basename $(readlink -f /usr/local/go))
if [ -d "/usr/local/$GO_VERSION" ]; then
	sudo rm /usr/local/go
	sudo ln -s /usr/local/$GO_VERSION /usr/local/go
	echo "Switched from $CURRENT_VERSION to $GO_VERSION"
	exit 0
fi


# download , extract and switch
wget https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
rc=$?
if [[ $rc -ne 0 ]]; then
	echo "Not found. Version still at $CURRENT_VERSION"
	exit 1
fi

# dirty hack to extract files , because I dont know how to extract go archive
# to a particular directory
sudo mkdir /usr/local/go-download
sudo tar -C /usr/local/go-download -xzf ${GO_VERSION}.linux-amd64.tar.gz
sudo mv /usr/local/go-download/go /usr/local/${GO_VERSION}
sudo rm /usr/local/go
sudo ln -s /usr/local/${GO_VERSION} /usr/local/go
sudo rm -r /usr/local/go-download

#remove the downloads
rm ${GO_VERSION}.linux-amd64.tar.gz

echo "Switched from $CURRENT_VERSION to $GO_VERSION"
