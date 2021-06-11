#!/bin/sh
REMOTE_HOST_PUBLIC_KEY=archethic_cs1.pub

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt-get update
sudo apt install miniupnpc -y

# Set SSL remote host public key as authorized key to connect and deploy code
cat $REMOTE_HOST_PUBLIC_KEY >> ~/.ssh/authorized_keys 



