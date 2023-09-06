#!/bin/bash

post_install_docker() {
    printf "\e${White}${InvertColors}Docker post install configuration. Continue? [y/n]${NC} "
    read post_install
    if [[ "$post_install" == [yY] ]]; then
        su $USER
        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp docker
    else
        printf "\e\n${Yellow}${Italic}Docker post install configuration canceled...${NC}"
        printf "\e\n${Yellow}${Italic}Docker post-install configuration must be done manually${NC}\n"
    fi
}
post_install_docker
