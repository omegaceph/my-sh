#!/bin/bash

is_valid_ip() {
    local ip="$1"
    local pattern_ip="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ $ip =~ $pattern_ip ]]; then
        return 0
    else
        return 1
    fi
}

while true; do
    printf "\n"
    read -p "Enter IP gateway: " network_ip
    if is_valid_ip "$network_ip"; then
        export network_ip
        break
    else
        printf "\n\e${Red}${Bold}Invalid ip gateway:${NC} $network_ip\n"
    fi
done
