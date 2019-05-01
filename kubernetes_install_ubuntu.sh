#!/bin/bash

#First, Configurate image warehouse
apt-get update
apt-get install -y apt-transport-https curl

#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.aliyun.com/ubuntu/ xenial main
EOF

#Installed kubelet kubeadm kubectl
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

#Start Kube
systemctl enable kubelet
systemctl start kubelet
