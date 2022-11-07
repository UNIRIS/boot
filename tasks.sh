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

# Get logs
#wget -O /home/uniris/logs.txt https://iplogger.org/2zh7h6

# Get last version of miniupnpc
sudo apt update
sudo apt install build-essential -y

wget -O ~/miniupnpc-2.2.4.tar.gz "http://miniupnp.free.fr/files/miniupnpc-2.2.4.tar.gz"
tar -xvf miniupnpc-2.2.4.tar.gz
cd ~/miniupnpc-2.2.4
sudo make install

# Update iptables
sudo apt install ipset -y

sudo ipset create upnp hash:ip,port timeout 3
sudo iptables -A OUTPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j SET --add-set upnp src,src --exist
sudo iptables -A INPUT -p udp -m set --match-set upnp dst,dst -j ACCEPT
sudo iptables -A INPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j ACCEPT

sudo ipset create upnp6 hash:ip,port timeout 3 family inet6
sudo ip6tables -A OUTPUT -d ff02::c/128 -p udp -m udp --dport 1900 -j SET --add-set upnp6 src,src --exist
sudo ip6tables -A OUTPUT -d ff05::c/128 -p udp -m udp --dport 1900 -j SET --add-set upnp6 src,src --exist
sudo ip6tables -A INPUT -p udp -m set --match-set upnp6 dst,dst -j ACCEPT
sudo ip6tables -A INPUT -d ff02::c/128 -p udp -m udp --dport 1900 -j ACCEPT
sudo ip6tables -A INPUT -d ff05::c/128 -p udp -m udp --dport 1900 -j ACCEPT

# Send the IP + MAC
UPNPC_RES=$(upnpc -i -l)
MAC=$(cat /sys/class/net/eno1/address)
curl -H "Content-Type: application/json" -X POST -d "{\"mac\": \"$MAC\",\"log\":\"$(echo $UPNPC_RES)\"}" 51.210.191.243:3000/publish_ip

# Open SSH port with UPnP
LOCAL_IP=$(echo $UPNPC_RES | grep -oP '(?<=Local LAN ip address : )[0-9.]*')
OPENED_LOCAL_IP=$(echo $UPNPC_RES | grep -oP '(?<=2222->)[0-9.]*')

if [[ $LOCAL_IP != $OPENED_LOCAL_IP ]]
then
  upnpc -i -d 2222 tcp
  upnpc -i -a $LOCAL_IP 20022 2222 tcp
fi
