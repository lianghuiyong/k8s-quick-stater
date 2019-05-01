#!/bin/bash

IMAGES_ADDRESS="gcrxio"

#Pull addon-resizer-amd64
docker pull ${IMAGES_ADDRESS}/addon-resizer-amd64:2.1
docker tag ${IMAGES_ADDRESS}/addon-resizer-amd64:2.1 gcr.io/google-containers/addon-resizer-amd64:2.1

#Pull kubernetes-dashboard-amd64
docker pull ${IMAGES_ADDRESS}/kubernetes-dashboard-amd64:v1.10.1
docker tag ${IMAGES_ADDRESS}/kubernetes-dashboard-amd64:v1.10.1 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1

#Pull metrics-server-amd64
docker pull ${IMAGES_ADDRESS}/metrics-server-amd64:v0.2.0
docker tag ${IMAGES_ADDRESS}/metrics-server-amd64:v0.2.0 gcr.io/google_containers/metrics-server-amd64:v0.2.0
#docker pull ${IMAGES_ADDRESS}/metrics-server-amd64:v0.3.1
#docker tag ${IMAGES_ADDRESS}/metrics-server-amd64:v0.3.1 k8s.gcr.io/metrics-server-amd64:v0.3.1
#docker pull ${IMAGES_ADDRESS}/addon-resizer:1.8.4
#docker tag ${IMAGES_ADDRESS}/addon-resizer:1.8.4 k8s.gcr.io/addon-resizer:1.8.4

#Pull efk
docker pull ${IMAGES_ADDRESS}/elasticsearch:v6.3.0
docker tag ${IMAGES_ADDRESS}/elasticsearch:v6.3.0 k8s.gcr.io/elasticsearch:v6.3.0
