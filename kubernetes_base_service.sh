#!/bin/bash
NAMESPACE="monitoring"

#Deploying dashbord UI
kubectl apply -f ./kubernetes-dashboard.yaml

#Install ingress-nginx
kubectl apply -f ingress/mandatory.yaml
kubectl apply -f ingress/cloud-generic.yaml
kubectl apply -f ingress/service-nodeport.yaml

#Install prometheus metrics
kubectl apply -f manifests/
until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f manifests/

#Install metrics server
kubectl apply -f metrics/metrics-server/

#Install custom metrics
kubectl apply -n monitoring -f metrics/custom-metrics/custom-metrics-apiserver-resource-reader-cluster-role-binding.yaml
kubectl apply -n monitoring -f metrics/custom-metrics/custom-metrics-apiservice.yaml
kubectl apply -n monitoring -f metrics/custom-metrics/custom-metrics-cluster-role.yaml
kubectl apply -n monitoring -f metrics/custom-metrics/custom-metrics-configmap.yaml
kubectl apply -n monitoring -f metrics/custom-metrics/hpa-custom-metrics-cluster-role-binding.yaml

#Install efk
kubectl apply -f efk/
