#!/bin/bash

ConfigureResolv() {
    resolv_file=/etc/resolv.conf
    
    printf "\n\e${Bold}Configuring $resolv_file${NC}"
    
    printf "domain localdomain\nsearch localdomain\nnameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver $ip_gateway\n" > $resolv_file
    
    cat $resolv_file
    printf "\e${Italic}Press ENTER to continue...${NC}\n"
    read
}
ConfigureResolv