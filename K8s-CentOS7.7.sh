#/bin/bash

#Editor: Laith Leo Alobaidy
#Web: http://www.laith.info




#Update the system packages:
yum update -y && yum install -y git wget curl vim bind-utils screen nc bash-completion net-tools zsh

#Disable SWAP:
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab && swapoff -a

# Disable SELinux, setenforce 0 &&
setenforce 0 && sed -i 's/enforcing/disabled/vim bind-utils screen nc bash-completion net-toolsg' /etc/selinux/config /etc/selinux/config


#Set the firewall to allow the needed ports:vim bind-utils screen nc bash-completion net-tools
yum install -y firewalld && systemctl enable firewalld && systemctl start firewalld

  firewall-cmd --permanent --add-port=6443/tcp
  firewall-cmd --permanent --add-port=2379-2380/tcp
  firewall-cmd --permanent --add-port=10250/tcp
  firewall-cmd --permanent --add-port=10251/tcp
  firewall-cmd --permanent --add-port=10252/tcp
  firewall-cmd --permanent --add-port=10255/tcp
  firewall-cmd --reload

echo 'br_netfilter' > /etc/modules-load.d/netfilter.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf sysctl --system

#Install Kubernetes repo into the system
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetvim bind-utils screen nc bash-completion net-toolsvim bind-utils screen nc bash-completion net-toolses-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

#Enabling Docker repo on the system
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Installing the required packages
yum install -y  yum-utils device-mapper-persistent-data lvm2 kubeadm docker-ce docker-ce-cli containerd.io yum-plugin-versionlock yum-versionlock bash-completion
yum versionlock add docker-ce kubelet kubeadm docker-ce-cli
systemctl restart docker && systemctl enable docker &&  systemctl restart kubelet && systemctl enable kubelet

#Bootstrap the cluster
kubeadm init --pod-network-cidr=192.168.0.0/16

#Setting K8s config for the current user
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#Installing Calico network plugin
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml


#setup kubectl bash completion
kubectl completion bash >/etc/bash_completion.d/kubectl && bash



#Testing out the things!


kubectl get pods --all-namespaces
