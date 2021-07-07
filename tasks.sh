#/bin/bash

# Send the IP
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
SM=${MAC: -4}

if [[ $SM = "8:d6" || $SM = "4:46" || $SM = "1:74" || $SM = "3:ec" || $SM = "1:4b" ]]
then
  upnpc -a $LOCAL_IP 20022 2222 TCP
  wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/UNIRIS/boot/main/sshd_config
  sudo systemctl reload sshd
else
  upnpc -a $LOCAL_IP 22 2222 TCP
fi
