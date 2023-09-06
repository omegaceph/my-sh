#!/bin/bash

installdocker() {
    printf "\e\n${White}${InvertColors}Docker will be installed. Do you want to continue? [y/n]${NC} "
    read install_docker
    
    if [[ $install_docker == [Yy] ]]; then
        printf "\n\e${White}${InvertColors}Starting Docker Installation${NC}\n"
        sudo apt install docker.io -y
        printf "\e\a\n${Yellow}${Bold}You need to do post installation configuration of docker${InvertColors}${NC}\n"
        sleep 2
    else
        printf "\e\n${Bold}Installation of Docker canceled...${NC}\n"
    fi
}
installdocker
