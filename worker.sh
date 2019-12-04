#Update the system packages:
yum update -y && yum install -y git wget curl vim bind-utils screen nc bash-compshletion net-tools zsh

#Disable SWAP:
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab && swapoff -a

# Disable SELinux, setenforce 0 &&
  firewall-cmd --permanent --add-port=10252/tcp
  firewall-cmd --permanent --add-port=10255/tcp
  firewall-cmd --reload

echo 'br_netfilter' > /etc/modules-load.d/netfilter.conf
  firewall-cmd --permanent --add-port=10252/tcp
  firewall-cmd --permanent --add-port=10255/tcp
  firewall-cmd --reload


echo 'br_netfilter' > /etc/modules-load.d/netfilter.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl --system

#Install Kubernetes repo into the system
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


#Enabling Docker repo on the system
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Installing the required packages
yum install -y yum-utils device-mapper-persistent-data lvm2 kubeadm docker-ce docker-ce-cli containerd.io yum-plugin-versionlock yum-versionlock bash-completion
yum versionlock add docker-ce kubelet kubeadm docker-ce-cli
systemctl restart docker && systemctl enable docker &&  systemctl restart kubelet && systemctl enable kubelet


