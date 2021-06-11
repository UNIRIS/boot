#!/bin/sh
REMOTE_HOST=51.210.191.243
REMOTE_USER=ubuntu
REMOTE_HOST_PUBLIC_KEY=archethic_cs1.pub

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt-get update
sudo apt install miniupnpc

# Generate key
ssh-keygen

# Send the public key
ssh-copy-id $REMOTE_USER@$REMOTE_HOST

# Add private key to the authentication agent
ssh-add

# Set SSL remote host public key as authorized key to connect and deploy code
cat $REMOTE_HOST_PUBLIC_KEY >> ~/.ssh/authorized_keys 


