#
/bin/bash

sudo su

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt-get update
sudo apt install miniupnpc sshpass -y

wget https://raw.githubusercontent.com/UNIRIS/boot/main/archethic_cs1.pub

# Set SSL remote host public key as authorized key to connect and deploy code
cat archethic_cs1.pub >> ~/.ssh/authorized_keys

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP

# Get Public IP
PUBLIC_IP=$(upnpc -s | grep -Po 'ExternalIPAddress = \K(.*)')

# Send the IP
echo "IP: $PUBLIC_IP" | sshpass -p bKwNZgctoLHU84ifpe8Cre8mm8 ssh info_nuc@51.210.191.243 "cat > $PUBLIC_IP"
