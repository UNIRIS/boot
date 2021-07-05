#/bin/bash

# Ensure the user is logged, otherwise ssh is not working
sleep 5

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool to open UPnP
sudo apt update
sudo apt install miniupnpc -y

# Download the archetic centralized server public key
wget -O /home/uniris/archethic_cs1.pub https://raw.githubusercontent.com/UNIRIS/boot/main/archethic_cs1.pub

# Set SSL remote host public key as authorized key to connect and deploy code
mkdir -p /home/uniris/.ssh
touch /home/uniris/.ssh/authorized_keys
cat /home/uniris/archethic_cs1.pub >> /home/uniris/.ssh/authorized_keys

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 20022 22 TCP
upnpc -a $LOCAL_IP 20022 2222 TCP

# Send the IP
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\" }" 51.210.191.243:3000/publish_ip

#Auto reboot
FILE=/home/uniris/TASKS
if grep -Fsxq "AUTOREBOOT" "$FILE"
then
    echo "FOUND"
else
    echo "NOTFOUND"
    touch "$FILE"
    echo "AUTOREBOOT" > "$FILE"
   ( sudo crontab -l 2>/dev/null; echo "@hourly wget -O /home/uniris/tasks.sh https://raw.githubusercontent.com/UNIRIS/boot/main/tasks.sh && /usr/bin/bash /home/uniris/tasks.sh" ) | sudo crontab - && sudo service cron start
fi
