# Shellscripts
This project consists of a set of Shell scripts designed to automate the configuration and installation of a server environment. It covers several essential steps to set up a server with the necessary functionalities. Below, we describe the key features and steps of the project:

<span style="color: orange">**Warning: This script is intended for non-production, testing, and development environments only. Using this script in a production environment can pose security risks and is strongly discouraged. Always follow best practices for production server configuration and security.**</span>

## Key Features:
### 1. Installation of Essential Packages:
The script begins by installing essential packages to ensure the server has all the necessary dependencies for subsequent steps.

### 2. Network Configuration:
The next step is network configuration. This involves setting up IP addresses and gateways, ensuring network connectivity is established and configured correctly.

### 3. Adding Firewall Rules:
To enhance server security, the script adds rules to the firewall. These rules are designed to control inbound and outbound traffic, allowing only necessary connections and blocking unwanted traffic.

### 4. Installation of Docker and Kubernetes:
The project automates the installation of Docker and Kubernetes. These tools are essential for deploying and managing containers and applications in a server environment.

### 5. Installation of iptables-persistent:
iptables-persistent is installed to ensure that the firewall rules are persistent and survive server reboots. This is crucial for maintaining firewall consistency and security.

### 6. Docker Post-Installation:
After Docker installation, the script performs necessary post-installation steps to configure Docker correctly and ensure it is ready for use.

## 🍍 Problems 🍍
* 3 error messages at the end of the script:
  * bash: ./.bashrc.colors: No such file or directory
  * bash: ./.bashrc.func: No such file or directory
  * bash: ./.bashrc.github: No such file or directory
* <s>Docker post install script is broken</s>
* <s>Network Config. Problem with conditional structure in network configuration.
(script.sh file) </s>
* <s>Firewall Config. The problem with the conditional structure of the network configuration,
script.sh file, affected the firewall settings. The variables used by the
firewall configuration come from the network settings.</s>

## 📝TODO
* If docker is not installed do not run docker post install script.
* file: configure_firewall
  * Check if firewall rules exist. part of command (example) grep -- "-A FORWARD -j DOCKER-USER"*
  * Check if firewall rules exist. (example) grep -- "-A FORWARD -j DOCKER-USER"
* file: configure_interfaces
  * Add more configuration options in the interfaces file
    * Add options for configuring IP, NETMASK, GATEWAY, BROADCAST... etc
* file: configure_resolv
  * Add more configuration options in the resolv.conf file
    * Add options to add more DNS
