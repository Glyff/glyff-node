#!/bin/bash

sudo apt-get install -y build-essential git-all wget
sudo apt-get update

wget --continue https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.8.1.linux-amd64.tar.gz

GLYFF_PATH="~vagrant/go/src/github.com/glyff/glyff-node/build/bin/"

echo "export PATH=$PATH:/usr/local/go/bin:$GLYFF_PATH" >> ~vagrant/.bashrc 
