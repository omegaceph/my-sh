#!/bin/bash

ConfigureInterfaces() {
    interface_file=/etc/network/interfaces
    
    printf "\n\e${Bold}Configuring $interface_file${NC}"
    
    printf "auto lo ens33\niface lo inet loopback\niface ens33 inet static\naddress $ipv4_address\ngateway $ip_gateway" > $interface_file
    
    cat $interface_file
}
ConfigureInterfaces