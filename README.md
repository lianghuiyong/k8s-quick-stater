# k8s快速部署

## 介绍

本工程的脚本是基于kubeadm快速部署k8s集群，对于k8s集群中的节点，分为两类，一类是Master节点，一类是Node节点。



## 安装步骤

### 安装Master

1)       把k8s脚本包通过SCP上传到Master服务器

2)       解压k8s脚本包

3)       CD到k8s目录，并授权chmod +x *.sh

4)       安装Docker

./docker_install_centos.sh

5)       安装kubernetes

./kubernetes_install_centos.sh

6)       拉取镜像

./kubernetes_images_pull.sh

7)       初始化Master

./kube_init.sh <内网IP>

8)       生成kube_join.sh文件

a)        sshpass –p <pwd> scp [root@ip:~/k8s/kube_init.log ./](mailto:root@ip:~/k8s/kube_init.log%20./)

b)       创建kube_join.sh脚本文件

c)        从kube_init.log文件中提取

kubeadm join xx.xx.xx.xx:6443 --token xxx --discovery-token-ca-cert-hash sha256:97068c5e408f21b65af82f6f0ebcf234285367cf00ee7ecd828d935ab2cdeb11到kube_join.sh中

 

### 添加Node节点

1)       把k8s脚本包和kube_join.sh通过SCP上传到Node服务器

2)       解压k8s脚本包，并授权chmod +x *.sh

3)       CD到k8s目录

4)       安装Docker

./docker_install_centos.sh

5)       安装kubernetes

./kubernetes_install_centos.sh

6)       拉取镜像

./kubernetes_images_pull.sh

7)       加入到集群

./kube_join.sh

 

### 通过Label对节点分类

1)       创建存储类节点

kubectl label nodes <node-name> nodetype=storage

2)       创建计算类节点

kubectl label nodes <node-name> nodetype=compute

3)       创建网关类节点

kubectl label nodes <node-name> nodetype=gateway

4)       二级分类（可选）

a)        创建MySQL节点

kubectl label nodes <node-name> storage=mysql

b)       创建Redis节点

kubectl label nodes <node-name> compute=redis

 

### 安装基本服务

1)       基本服务有

a)        资源监控，通过Prometheus-operator来实现

b)       Kubernetes 的HPA，能过Metrics service 来实现

c)        集群日志通过EFK来实现

2)       执行安装脚本

./kubernetes_base_serivce.sh

### 创建Namespace

# 创建Namespace

1)       创建开发环境名命空间

kubectl apply –f ./namespaces/development.yaml

kubectl apply –f ./namespaces/development-resources.yaml

2)       创建生产环境名命空间

kubectl apply –f ./namespaces/production.yaml

kubectl apply –f ./namespaces/production-resources.yaml

### 客户端安装配置kubectl

1)       安装kubectl

./kubernetes_install_centos.sh

2)       配置kubectl

sshpass –p <pwd> scp [root@ip:/etc/kubernetes/admin.conf ./](mailto:root@ip:/etc/kubernetes/admin.conf%20./)dev_kube.conf

3)       使用kubectl操作集群

kubectl –kubeconfig=dev_kube.conf –n development

 

注：

1)       先在本地安装sshpass，并把 StrictHostKeyChecking no加到/etc/ssh/ssh_config可以让ssh客户端自动接受新主机的hostkey

2)       目前案例并没有建立PV，所以Prometheus和Elasticsearch的数据都是存储在临时目录中，关闭程序会丢失数据