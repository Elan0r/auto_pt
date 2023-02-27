#!/bin/bash

figlet -w 90 ProSecPassiveRecon

# create Folder
/opt/auto_pt/scripts/b10-folder.sh

if [ -d /opt/PCredz/logs ]; then
  echo '! > Logfolder OK.'
else
  mkdir -p /opt/PCredz/logs
fi

echo "Start Passive Recon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

tmux new-window -n:Passive-Recon
tmux send 'netdiscover -p -L -i eth0 | tee -a /root/output/netdiscover.txt' ENTER
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -ctv' ENTER
tmux split-window
tmux send 'timeout 300 tcpdump -i eth0 -w /root/output/loot/intern/network/passive.pcap' ENTER
echo '! >'
echo '! > tmux a ;if you have the dfitmux.conf xD'
