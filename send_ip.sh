#!/bin/sh

REMOTE_HOST=51.210.191.243
REMOTE_USER=ubuntu

# Open SSH port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP

# Get Public IP
PUBLIC_IP=$(upnpc -s | grep -Po 'ExternalIPAddress = \K(.*)')

# Send the IP
echo "$PUBLIC_IP" | ssh -i nuc_key $REMOTE_USER@$REMOTE_HOST "cat >> ip_list | sort -u "


