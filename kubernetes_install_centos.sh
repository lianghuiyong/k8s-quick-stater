#!/bin/bash
kube_version="1.13.4-0"
kube_cni_version="0.6.0"

#First, Close selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#Second, Configurate image warehouse
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

#Installed kubelet kubeadm kubectl
yum install -y kubelet-${kube_version} \
kubeadm-${kube_version} \
kubectl-${kube_version} \
kubernetes-cni-${kube_cni_version} \
--disableexcludes=kubernetes

#Configurate netfilter
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness=0
vm.overcommit_memory=1
fs.inotify.max_user_watches=89100
fs.file-max = 6553560
fs.nr_open = 6553560
EOF

sysctl --system

#Close swap
swapoff -a

#Start Kube
systemctl enable kubelet
systemctl start kubelet
