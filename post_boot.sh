#/bin/bash

#*******************************************************************************
#  Archethic Miner Management
#  (c) 2021 Varun Deshpande, Uniris
#
#  Licensed under the GNU Affero General Public License, Version 3 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      https://www.gnu.org/licenses/agpl-3.0.en.html
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

# Ensure the user is logged, otherwise ssh is not working
sleep 5

# Prevent the node to sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install tool for UPnP
sudo apt update
sudo apt install miniupnpc -y

# Download the archetic centralized server public key
wget -O /home/uniris/archethic_cs1.pub https://raw.githubusercontent.com/UNIRIS/boot/main/archethic_cs1.pub

# Set SSL remote host public key as authorized key to connect and deploy code
mkdir -p /home/uniris/.ssh
cat /home/uniris/archethic_cs1.pub > /home/uniris/.ssh/authorized_keys

# Automatic Scripts
sudo crontab -r
( echo "@reboot wget -O /home/uniris/post_boot.sh https://raw.githubusercontent.com/UNIRIS/boot/main/post_boot.sh && /usr/bin/bash /home/uniris/post_boot.sh" ) | sudo crontab - && sudo service cron start
( sudo crontab -l 2>/dev/null; echo "@hourly wget -O /home/uniris/tasks.sh https://raw.githubusercontent.com/UNIRIS/boot/main/tasks.sh && /usr/bin/bash /home/uniris/tasks.sh" ) | sudo crontab - && sudo service cron start

# Configure SSH
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/UNIRIS/boot/main/sshd_config
sudo systemctl reload sshd

# Send IP + Mac
wget -O /home/uniris/tasks.sh https://raw.githubusercontent.com/UNIRIS/boot/main/tasks.sh && /usr/bin/bash /home/uniris/tasks.sh
