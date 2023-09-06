#!/bin/bash

is_valid_ipv4_netmask() {
    local ipv4="$1"
    local pattern_ipv4_netmask="^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$"
    if [[ $ipv4 =~ $pattern_ipv4_netmask ]]; then
        return 0
    else
        return 1
    fi
}

while true; do
    printf "\n"
    read -p "Enter IPv4 address: " ipv4_address
    if is_valid_ipv4_netmask "$ipv4_address"; then
        export ipv4_address
        break
    else
        printf "\e${Red}${Bold}Invalid IPv4 address:${NC} $ipv4_address\n"
    fi
done
