#!/bin/bash

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -d /opt/PCredz/logs ]; then
    echo '! > Logfolder OK.'
else
     mkdir -p /opt/PCredz/logs
fi

tmux -f /opt/hacking/dfi/dfitmux.conf new-session -d
tmux rename-window 'Passive-Recon'

figlet -w 90 ProSecPassiveRecon > /dev/pts/1
figlet -w 90 ProSecPassiveRecon > /dev/pts/0

tmux send 'netdiscover -p -L -i eth0 | tee -a /root/output/netdiscover' ENTER
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -c' ENTER
tmux split-window
tmux send 'timeout 300 tcpdump -i eth0 -w /root/output/loot/passive.pcap && exit' ENTER
echo '! >'
echo '! > tmux a ;if you have the dfitmux.conf xD'
