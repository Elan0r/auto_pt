#!/bin/bash
# shellcheck disable=SC2034
#Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

echo -e "${RED}"
figlet Cleaner
echo '! > Cleaning all!'
echo -e "${NC}"

msfdb start
msfconsole -qx 'workspace -D; exit'

rm -r /root/input
rm -r /root/output
rm -r /root/output*
rm -r /root/customer
rm -r /root/.cme
rm -r /usr/share/responder/logs
rm -r /usr/share/responder/Responder.db
rm -r /opt/PCredz/logs
mkdir /opt/PCredz/logs
rm -r /root/.msf4/loot
rm -r /root/dump
rm /opt/PCredz/CredentialDump-Session.log
rm /root/.msf4/history
rm /root/.zsh_history
rm /root/.bash_history
rm /root/*.log
rm /root/*.ntds
rm /root/*.ntds.*
rm /root/*.sam
rm /root/*.secrets
rm /root/*.kerberos
rm /root/*.txt
rm /root/bettercap.history
rm /root/arp.cache
rm /root/*.restore
rm /root/*.pcap
rm /root/*.json
rm /root/*.pfx
rm /root/*.ccache
rm /root/sessionresume*
rm /root/*.zip

chattr -i /etc/resolv.conf
rm /etc/resolv.conf.dhclient-new.*

docker stop "$(docker ps -aq)"
docker container prune -f
docker image prune -f
docker volume prune -f
docker network prune -f
docker system prune -f

echo -e "${GREEN}! > CLEAN! ${NC}"
