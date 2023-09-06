#!/bin/bash

is_valid_ip_gateway() {
    local ip="$1"
    local pattern_ip_gateway="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ $ip =~ $pattern_ip_gateway ]]; then
        return 0
    else
        return 1
    fi
}

while true; do
    printf "\n"
    read -p "Enter IP gateway: " ip_gateway
    if is_valid_ip_gateway "$ip_gateway"; then
        export ip_gateway
        break
    else
        printf "\n\e${Red}${Bold}Invalid ip gateway:${NC} $ip_gateway\n"
    fi
done
