#!/bin/bash

ConfigureResolv() {
    printf "\n\e${Bold}Configuring $resolv_conf_file${NC}"
    
    printf "domain localdomain\nsearch localdomain\nnameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver $network_ip\n" > $resolv_conf_file
    
    cat $resolv_conf_file
    printf "\e${Italic}Press ENTER to continue...${NC}\n"
    read
}
ConfigureResolv