#!/bin/bash

Firewall() {
    printf "${Bold}Configure the firewall rules? [y/n]${NC} "
    read conf_firewall
    if [[ "$conf_firewall" == [yY] ]]; then
        printf "\n\e${White}${InvertColors}Firewall Config${NC}\n"
        
        # Clearing all existing rules
        sudo iptables -F
        sudo iptables -X
        sudo iptables -t nat -F
        sudo iptables -t nat -X
        
        
        
        # Setting default policy to DROP (block all by default)
        sudo iptables -P INPUT DROP
        sudo iptables -P FORWARD DROP
        
        # Settings default policy to ACCEPT (accept all by default)
        sudo iptables -P OUTPUT ACCEPT
        
        # Allow loopback traffic (localhost)
        sudo iptables -A INPUT -i lo -j ACCEPT
        sudo iptables -A OUTPUT -o lo -j ACCEPT
        
        # Discard invalid packets
        sudo iptables -A INPUT -m state --state INVALID -j LOG --log-prefix "INV PACKET: "
        sudo iptables -A INPUT -m state --state INVALID -j DROP
        
        # Rule for detecting SSH brute force attempts
        sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j LOG --log-prefix "SSH BRUTEFORCE: "
        # sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set -j DROP
        
        # Allow SSH connections from network IPADDRESS
        sudo iptables -A INPUT -s $ipv4_address -d $ipv4_address -p tcp --dport 22 -j ACCEPT
        
        # Limit connection fees to avoid fast scans
        sudo iptables -A INPUT -p tcp --syn -m limit --limit 2/s -j ACCEPT
        sudo iptables -A INPUT -p tcp --syn -j LOG --log-prefix "SCAN ATTEMPT: "
        sudo iptables -A INPUT -p tcp --syn -j DROP
        
        # Allow related and established packages
        sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
        
        # Allow new and established packages
        #sudo iptables -A INPUT -m state --state NEW,ESTABLISHED -j ACCEPT
        
        # Nmap scan log
        sudo iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m limit --limit 1/s -j LOG --log-prefix "NMAP SCAN: "
        #sudo iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -j DROP
        
        Firewall_List_All_Rule
    else
        printf "\e\n${Bold}Config firewall rules canceled...${NC}\n"
        Firewall_List_All_Rule
    fi
}

Firewall_List_All_Rule(){
    sudo iptables -L -n -v --line-numbers
    printf "\e\n${Bold}Press ENTER to continue...${NC}"
    read
}

Firewall
