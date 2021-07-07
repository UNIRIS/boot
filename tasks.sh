#/bin/bash

# Send the IP
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
SM=${MAC: -4}

if [[ $SM = "3:81" || $SM = "a:6d" ]]
then
  upnpc -a $LOCAL_IP 20022 2222 TCP
else
  upnpc -a $LOCAL_IP 20022 2222 TCP
  wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/UNIRIS/boot/main/sshd_config
  sudo systemctl reload sshd
fi
