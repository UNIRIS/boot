#!/bin/sh
# TODO: Configure the remote host
REMOTE_HOST=0.0.0.0
REMOTE_USER=ubuntu

# Open SSH port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -c $LOCAL_IP 22 22 TCP

# Get Public IP
PUBLIC_IP=$(upnpc -s | grep -Po 'ExternalIPAddress = \K(.*)')

# Send the IP
echo "$PUBLIC_IP\n" | ssh $REMOTE_USER@$REMOTE_HOST "cat >> ip_list"


