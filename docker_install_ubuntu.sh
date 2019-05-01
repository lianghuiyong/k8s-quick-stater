#!/bin/bash

# This script displays docker be installed

# First, Remove old docker
apt-get remove docker \
docker-engine \
docker.io

#If system version is trusty then installed this package for used aufs
if [ "trusty" = lsb_release -cs ] then
    apt-get update
    apt-get install inux-image-extra-$(uname -r) \
    linux-image-extra-virtual
fi
  
#Second, Configuration docker image warehouse
apt-get update
apt-get install apt-transport-https \
ca-certificates \
curl \
software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

#Final, Install Docker-ce
apt-get update
apt-get install docker-ce=<18.06.1~ce~3-0~ubuntu>

# Start docker
systemctl enable docker
systemctl start docker
