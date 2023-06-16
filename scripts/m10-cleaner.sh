#!/bin/bash

figlet Cleaner

echo '! > Cleaning all!'
msfdb start
msfconsole -qx 'workspace -D; exit'

rm -r /root/input
rm -r /root/output
rm -r /root/output*
rm -r /root/customer
rm -r /root/.cme
rm -r /usr/share/responder/logs
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

echo "! > CLEAN!"
