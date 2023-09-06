#!/bin/bash

installkubernetes() {
    printf "\e${White}${InvertColors}The following additional packages will be installed: Kubernetes. Do you want to continue? [y/n]${NC}"
    read install_kubernetes

    if [[ $install_kubernetes == [Yy] ]]; then
        printf "\e\n${White}${InvertColors}Starting Kubernetes installation${NC}\n"
        
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        
        sudo apt update
        
        sudo apt install kubeadm kubelet kubectl kubernetes-cni -y
    else
        printf "\e\n${Yellow}${Bold}Installation of Kubernetes canceled...${NC}\n"
    fi
}
installkubernetes