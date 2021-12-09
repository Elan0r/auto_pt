#!/bin/bash

figlet ProSecClean
echo '! > Cleaning all!'
msfdb start
msfconsole -qx 'workspace -D; exit'

rm -r /root/input
rm -r /root/output
rm -r /root/.cme
rm -r /usr/share/responder/logs
rm -r /opt/PCredz/logs
mkdir /opt/PCredz/logs
rm -r /root/.msf4/loot
rm /opt/PCredz/CredentialDump-Session.log
rm /root/.msf4/history
rm /root/.zsh_history
rm /root/.bash_history
rm /root/*.log
rm /root/*.txt
rm /root/bettercap.history
rm /root/arp.cache
rm /root/*.restore
rm /root/*.pcap

chattr -i /etc/resolv.conf

echo "! > CLEAN!"
