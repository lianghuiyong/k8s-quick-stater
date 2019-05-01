#!/bin/bash

PODS_ON_MSATER="yes"

if [ x$1 != x ]; then
  sed -ig "s/advertiseAddress: .*$/advertiseAddress: $1/" ./kube_config.yaml
else
  echo "Must input the master ip addr."
  exit
fi

#Init kubernetes
kubeadm init --config ./kube_config.yaml | tee ./kube_init.log

#Create the config file of kubernetes
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#Install pod network
ETCD_CA_PATH=/etc/kubernetes/pki/etcd

if [ x$1 != x ]; then
  sed -ig "s/etcd_endpoints: .*$/etcd_endpoints: \"$1:2379\"/" ./calico.yaml
fi

if [ -d "$ETCD_CA_PATH" ]; then
  ETCD_KEY=`cat /etc/kubernetes/pki/etcd/server.key | base64 -w 0`
  ETCD_CERT=`cat /etc/kubernetes/pki/etcd/server.crt | base64 -w 0`
  ETCD_CA=`cat /etc/kubernetes/pki/etcd/ca.crt | base64 -w 0`

  sed -ig "s/etcd-key: .*\#base64$/etcd-key: ${ETCD_KEY} \#base64/" ./calico.yaml
  sed -ig "s/etcd-cert: .*\#base64$/etcd-cert: ${ETCD_CERT} \#base64/" ./calico.yaml
  sed -ig "s/etcd-ca: .*\#base64$/etcd-ca: ${ETCD_CA} \#base64/" ./calico.yaml
fi

kubectl apply -f ./calico.yaml

#Schedule pods on the master
if [ "yes" == "${PODS_ON_MSATER}" ]; then
  kubectl taint nodes --all node-role.kubernetes.io/master-
fi
