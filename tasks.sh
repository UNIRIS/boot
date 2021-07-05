#/bin/bash
#sudo reboot now

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP
upnpc -a $LOCAL_IP 22 2222 TCP

# Send the IP
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

SM=${MAC: -4}

#if [[ $SM = "0b" || $SM = "33" ]]
if [[ $SM = "1:4b" ]]
then
  upnpc -a $LOCAL_IP 20022 2222 TCP
  wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/UNIRIS/boot/main/sshd_config
  sudo systemctl reload sshd
fi
