#!/bin/sh
# TODO: Configure the remote host
REMOTE_HOST=0.0.0.0
REMOTE_USER=ubuntu

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
# TODO 


