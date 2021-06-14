#!/bin/bash

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt-get update
sudo apt install miniupnpc -y

wget -O https://raw.githubusercontent.com/UNIRIS/boot/main/archethic_cs1.pub

# Set SSL remote host public key as authorized key to connect and deploy code
cat archethic_cs1.pub >> ~/.ssh/authorized_keys

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP

# TODO: once the ssh access is working and we get the nuc_key private key
# # Get Public IP
# PUBLIC_IP=$(upnpc -s | grep -Po 'ExternalIPAddress = \K(.*)')
# 
# # Send the IP
# echo "$PUBLIC_IP" | ssh -i nuc_key ubuntu@51.210.191.243 "cat >> ip_list"

