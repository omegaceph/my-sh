#!/bin/bash

Firewall(){
    ip address show
    printf "\e\n${Bold}Press ENTER to continue...${NC}\n"
    read
    
    printf "\e\n${Bold}Enter external interface:${NC}\n "
    read external_interface
    
    printf "\e\n${Bold}Enter internal interface:${NC}\n "
    read internal_interface
    
    printf "\e\n${Bold}Enter internal Network IP:${NC}\n "
    read internal_network
    
    external_interface="$external_interface"
    internal_interface="$internal_interface"
    internal_network="$internal_network"
    
    printf "\e\n${Bold}Clearing policies .............................. ${Green}[ OK ]${NC}\n"
    iptables -X
    iptables -Z
    iptables -F INPUT
    iptables -F OUTPUT
    iptables -F FORWARD
    iptables -F -t nat
    iptables -F -t filter
    iptables -F -t mangle
    
    printf "\e\n${Bold}Apply new policy        ......................... ${Green}[ OK ]${NC}\n"
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP
    
    printf "\e\n${Bold}Activating modules ........................... ${Green}[ OK ]${NC}\n"
    modprobe ip_tables
    modprobe ip_conntrack
    modprobe iptable_filter
    modprobe iptable_mangle
    modprobe iptable_nat
    modprobe ipt_LOG
    modprobe ipt_limit
    modprobe ipt_state
    modprobe ipt_REDIRECT
    modprobe ipt_owner
    modprobe ipt_REJECT
    modprobe ipt_MASQUERADE
    modprobe ip_conntrack_ftp
    modprobe ip_nat_ftp
    
    printf "\e\nKernal Routing ............................ ${Green}[ OK ]${NC}\n"
    echo 1 > /proc/sys/net/ipv4/ip_forward
    
    printf "\e\n${Bold}Internet sharing ........................... ${Green}[ OK ]${NC}\n"
    iptables -t nat -A POSTROUTING -o $external -j MASQUERADE
    
    printf "\e\n${Bold}Keeping connections ................. ${Green}[ OK ]${NC}\n"
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A FORWARD -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
    iptables -A OUTPUT -m state --state RELATED,ESTABLISHED,NEW -j ACCEPT
    
    printf "\e\n${Bold}Logs ............................... ${Green}[ OK ]${NC}\n"
    iptables -A INPUT -j LOG
    iptables -A OUTPUT -j LOG
    iptables -A FORWARD -j LOG
    
    printf "\e\n${Bold}DNAT rules for WEB server ................... ${Green}[ OK ]${NC}\n"
    iptables -t nat -A PREROUTING -i $external -p tcp --dport 80 -j DNAT --to $internal_network:80
    
    #printf "\e\n${Bold}Website blocking ............................... ${Green}[ OK ]${NC}\n"
    #iptables -A FORWARD -d 173.252.91.4/25 -j REJECT
    #iptables -A FORWARD -d 31.13.73.1/25 -j REJECT
    
    #REGRAS FORWARD
    printf "\e\n${Bold}Allows ping to external network ................... ${Green}[ OK ]${NC}\n"
    iptables -A FORWARD -i $internal -o $external -p icmp -j ACCEPT
    
    printf "\e\n${Bold}Allow connections from internal to external network .... ${Green}[ OK ]${NC}\n"
    iptables -A FORWARD -i $internal -o $external -p tcp -m multiport --dports 80,443,3128,110,20,21,587,995,143,22,3389,25,5900,5100,3389 -j ACCEPT
    
    printf "\e\n${Bold}Client Rules .................................. ${Green}[ OK ]${NC}\n"
    iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    
    printf "\e\n${Bold}Server Rules ................................. ${Green}[ OK ]${NC}\n"
    iptables -A INPUT -p tcp -i $internal --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp -i $internal -m multiport --dports 3128,443,445,113,80,587,25,22,110,53,139,5900,5100,3389 -j ACCEPT
    iptables -A INPUT -p udp -i $internal -m multiport --dports 53,110,67,68,137,113,443,138 -j ACCEPT
    
    #printf "\e\n${Bold}Port forwarding ....................... ${Green}[ OK ]${NC}\n"
    #iptables -t nat -A PREROUTING -i $internal -p tcp --dport 80 -j REDIRECT --to-port 3128
    
    printf "\e\n${Bold}Ping ICMP ............................. ${Green}[ OK ]${NC}\n"
    iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j ACCEPT
    iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:
    iptables -A INPUT -p icmp -j DROP
    iptables -A OUTPUT -p icmp -j ACCEPT
    
    printf "\e\n${Bold}Loopback connections ....................... ${Green}[ OK ]${NC}\n"
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    
    printf "\e\n${Bold}##################### SECURITY ########################${NC}\n"
    
    echo "IP Spoofing Security .................... [ OK ]"
    echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
    iptables -A INPUT -m state --state INVALID -j DROP
    
    echo "Route change protection ............... [ OK ]"
    echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
    
    echo "Path change protection ............ [ OK ]"
    echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
    
    echo "Bogus responses Protection  ................. [ OK ]"
    echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
    
    echo "Block traceroute ........................... [ OK ]"
    iptables -A INPUT -p udp -s 0/0 -i $internal --dport 33435:33525 -j DROP
    
    echo "SYN flood protection ......................... [ OK ]"
    echo 1 > /proc/sys/net/ipv4/tcp_syncookies
    iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
    iptables -A FORWARD -p tcp --syn -j DROP
    
    echo "Denying invalid ports (trojans, trinoo) ...... [ OK ]"
    iptables -A INPUT -p tcp -i $external -m multiport --dports 666,4000,6000,6006,16660,27444,27665,31335,34555,35555 -j DROP
    iptables -A INPUT -p tcp -i $internal -m multiport --dports 1433,6670,6711,6712,6713,12345,12346,20034,31337,6000 -j DROP
    
    echo "Telnet protection .......................... [ OK ]"
    iptables -A INPUT -p TCP -i $external --dport telnet -j DROP
    
    echo "Dropping TCP packets ............... [ OK ]"
    iptables -A FORWARD -p tcp ! --syn -m state --state NEW -j DROP
    
    echo "Worms protection ........................... [ OK ]"
    iptables -A FORWARD -p tcp --dport 135 -i $external -j REJECT
    
    echo "ICMP Broadcasting protection ............... [ OK ]"
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
    
    echo "Port Scanners protection ........... [ OK ]"
    iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
    iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
    
    echo "Ping protection ................... [ OK ]"
    iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
    
    echo "IP Spoofing protection ..................... [ OK ]"
    iptables -A INPUT -s 172.16.0.0/12 -i $external -j DROP
    iptables -A INPUT -s 127.0.0.0/8 -i $external -j DROP
    iptables -A INPUT -s 10.0.0.0/8 -i $external -j DROP
    iptables -A INPUT -s 192.168.0.0/16 -i $external -j DROP
    
    echo "Blocking Fragmented Packets.................. [ OK ]"
    iptables -A INPUT -i $external -f -j LOG --log-prefix "Fragmented Packets: "
    iptables -A INPUT -i $external -f -j DROP
    iptables -A INPUT -i $internal -f -j LOG --log-prefix "Fragmented Packets: "
    iptables -A INPUT -i $internal -f -j DROP
}
Firewall