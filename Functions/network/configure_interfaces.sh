#!/bin/bash

ConfigureInterfaces() {
    printf "\n\e${Bold}Configuring $network_interface_file${NC}"
    
    printf "\e\n${Bold}Enter interface name (eth0, ens33, etc...)${NC} "
    read interface

    printf "auto lo $interface\niface lo inet loopback\niface $interface inet static\naddress $ipv4_address_netmask\ngateway $network_ip\n" > $network_interface_file
    
    cat $network_interface_file
}
ConfigureInterfaces