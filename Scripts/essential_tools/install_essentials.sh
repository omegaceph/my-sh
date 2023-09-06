#!/bin/bash

install_essentials() {
    printf "\n\e${White}${InvertColors}START Essentials Script${NC}\n"
    
    apt install sudo -y
    
    source ./Functions/administrator/check_user_sudo.sh
    
    sudo apt install curl -y
    sudo apt install apt-transport-https ca-certificates -y
    sudo apt install software-properties-common -y
    sudo apt install gpg -y
    sudo apt install coreutils -y
    sudo apt install net-tools -y
    sudo apt install iptables -y
    sudo apt install nano -y
    
    printf "\a"
    echo ""
}
install_essentials