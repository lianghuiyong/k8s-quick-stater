#!/bin/bash
docker_version="18.03.1.ce-1.el7.centos"

# This script displays docker be installed

# First, Remove old docker
yum remove -y docker \
docker-common \
docker-selinux \
docker-engine

#Second, Configuration docker image warehouse
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2

yum-config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

#Final, Install Docker-ce
yum makecache fast
yum install -y docker-ce-${docker_version}

# Start docker
systemctl enable docker
systemctl start docker
