#!/bin/bash

# Extract IP and gateway address from interfaces
export ipv4=$(cat $network_interface_file | grep -Po "address \K[\d./]+")
export ip_gw=$(cat $network_interface_file | grep -Po "gateway \K[\d.]+")

# The complete command takes an IPv4 address, removes the trailing part (the last group of digits) and replaces it with "0".
export ipv4_address=$(echo $ipv4 | sed -E 's/([0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+/\10/')

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
    read -p "Enter IPv4 address: " ipv4_address_netmask
    if is_valid_ipv4_netmask "$ipv4_address_netmask"; then
        export ipv4_address_netmask
        break
    else
        printf "\e${Red}${Bold}Invalid IPv4 address:${NC} $ipv4_address_netmask\n"
    fi
done
