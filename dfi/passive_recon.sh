#!/bin/bash

#create Folders
/opt/hacking/dfi/folder.sh

if [ -d /opt/PCredz/logs ]; then
    echo '! > Logfolder OK.'
else
     mkdir -p /opt/PCredz/logs
fi

tmux -f /opt/hacking/dfi/dfitmux.conf new-session -d
tmux rename-window 'Passive-Recon'

figlet -w 90 ProSecPassiveRecon > /dev/pts/1
figlet -w 90 ProSecPassiveRecon > /dev/pts/0

tmux send 'netdiscover -p -L -i eth0 | tee -a /root/output/netdiscover.txt' ENTER
tmux split-window
tmux send 'python3.9 /opt/PCredz/Pcredz -i eth0 -ctv' ENTER
tmux split-window
tmux send 'timeout 300 tcpdump -i eth0 -w /root/output/loot/intern/network/passive.pcap' ENTER
echo '! >'
echo '! > tmux a ;if you have the dfitmux.conf xD'
