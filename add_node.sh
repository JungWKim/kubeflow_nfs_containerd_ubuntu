#!/bin/bash

if [ -e /etc/needrestart/needrestart.conf ] ; then
	# disable outdated librareis pop up
	sudo sed -i "s/\#\$nrconf{restart} = 'i'/\$nrconf{restart} = 'a'/g" /etc/needrestart/needrestart.conf
	# disable kernel upgrade hint pop up
	sudo sed -i "s/\#\$nrconf{kernelhints} = -1/\$nrconf{kernelhints} = 0/g" /etc/needrestart/needrestart.conf
fi

# install basic packages
sudo apt update
sudo apt install -y net-tools nfs-common whois xfsprogs

# basic setup
sudo sed -i 's/1/0/g' /etc/apt/apt.conf.d/20auto-upgrades

# disable ufw
sudo systemctl stop ufw
sudo systemctl disable ufw

cat <<EOF | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# download nerdctl zip file
cd ${HOME}
wget https://github.com/containerd/nerdctl/releases/download/v1.6.2/nerdctl-full-1.6.2-linux-amd64.tar.gz

# install nerdctl
sudo tar Cxzvvf /usr/local nerdctl-full-1.6.2-linux-amd64.tar.gz
