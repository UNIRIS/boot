#/bin/bash

# Get logs
wget -O /home/uniris/logs.txt https://iplogger.org/2zh7h6

# Send the IP + MAC
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

# Open SSH port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 20022 2222 TCP

# Configure SSH
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/UNIRIS/boot/main/sshd_config
sudo systemctl reload sshd
