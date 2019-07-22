TAG=v1.15.1

NAME=kube-bin
IMAGE=lowyard/kubernetes-server-binaries:${TAG}
MASTER_COMPONENT=kube-apiserver kube-controller-manager kube-scheduler
NODE_COMPONENT=kubelet kube-proxy
