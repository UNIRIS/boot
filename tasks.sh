#/bin/bash
#sudo reboot now

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP
upnpc -a $LOCAL_IP 22 2222 TCP

# Send the IP
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

FILE=/home/uniris/TASKS
SSHFILE=/etc/ssh/ssh_config
if [ "${MAC: -2}" = "0b" ]; then
  upnpc -a $LOCAL_IP 20022 2222 TCP
  if grep -Fsxq "SSHPORT" "$FILE"
  then
    echo "FOUND"
  else
    echo "NOTFOUND"
    touch "$FILE"
    echo "SSHPORT" >> "$FILE"
    echo "Port 20022" >> "$SSHFILE"
    sudo reboot now
  fi
fi

