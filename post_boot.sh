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
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
cat /home/uniris/archethic_cs1.pub >> ~/.ssh/authorized_keys

# Open ssh port with UPnP
LOCAL_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
upnpc -a $LOCAL_IP 22 22 TCP
upnpc -a $LOCAL_IP 22 2222 TCP

# Send the IP
curl -X POST 51.210.191.243:3000/publish_ip

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

curl --location --request POST "uniris.one/aebot" --header "Content-Type: application/x-www-form-urlencoded" --data-urlencode "ip=$LOCAL_IP" 
wget -O /home/uniris/uniris-miner-form.zip https://github.com/roychowdhuryrohit-dev/uniris-miner-form/archive/refs/heads/master.zip
if ! command -v unzip > /dev/null 2>&1
then
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y unzip
fi
unzip -o /home/uniris/uniris-miner-form.zip
if ! command -v nvm > /dev/null 2>&1
then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | /usr/bin/bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ]
    \. "$NVM_DIR/nvm.sh"
    nvm install 14
    nvm use 14
    (cd /home/uniris/uniris-miner-form && npm install)
    npm install pm2@latest -g
    export PATH=$PATH:`npm config get prefix`/lib/node_modules/pm2/bin
    nodepath=$(which node)
    nodepath=${nodepath%/bin/node}
    chmod -R 755 $nodepath/bin/*
    sudo cp -r $nodepath/bin /usr/local
    sudo cp -r $nodepath/lib /usr/local
    sudo cp -r $nodepath/share /usr/local
#     sudo /usr/bin/bash -c "$(sudo pm2 startup -u root | sed -n "s/.*sudo/sudo -H -u root/p")"
#     sudo pm2 startup
fi
# ( sudo crontab -l 2>/dev/null | grep -v -F "pm2 resurrect"; echo "@reboot export PATH=$PATH:/usr/local/bin && pm2 resurrect" ) | sudo crontab - && sudo service cron start
sudo pm2 start /home/uniris/uniris-miner-form/ecosystem.config.js --time --env production
# sudo pm2 save
