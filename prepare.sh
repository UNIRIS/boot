#!/bin/sh

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt-get update
sudo apt install miniupnpc

# Open SSH port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -c $LOCAL_IP 22 22 TCP

# Get Public IP
PUBLIC_IP=$(upnpc -s | grep -Po 'ExternalIPAddress = \K(.*)')
