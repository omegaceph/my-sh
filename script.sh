#!/bin/bash
source ./common/colors.sh

printf "\e\n${Yellow}${Bold}${InvertColors}Do not run this script with 'sudo su' command${NC}\n"

sleep 2

apt update

source ./Scripts/essential_tools/install_essentials.sh

printf "${Bold}Configure the network? [y/n]${NC} "
read conf_network
if [[ "$conf_network" == [yY] ]]; then
    printf "\n\e${White}${InvertColors}/etc/network/interfaces${NC}\n"
    cat /etc/network/interfaces
    
    printf "\n\e${White}${InvertColors}/etc/resolv.conf${NC}\n"
    cat $resolv_conf_file
    
    printf "\e\n${Bold}Press ENTER to continue...${NC}"
    read
    
    source ./Functions/network/validade_ipv4_netmask.sh
    source ./Functions/network/validate_ip.sh
    source ./Functions/network/configure_interfaces.sh
    source ./Functions/network/configure_resolv.sh
fi

source ./Scripts/firewall/configure_firewall.sh
source ./Scripts/docker/install_docker.sh
source ./Scripts/kubernetes/install_kubernetes.sh
source ./Scripts/essential_tools/iptables-persistent.sh
source ./Scripts/essential_tools/tuneup_unix.sh
source ./Scripts/docker/post_installation_docker.sh
