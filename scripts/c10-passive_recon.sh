#!/bin/bash

figlet PassiveRecon

echo "Start Passive Recon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

tmux new-window -n:Passive-Recon
tmux send 'netdiscover -p -L -i eth0 | tee -a /root/output/netdiscover.txt' ENTER
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -ctv' ENTER
tmux split-window
tmux send 'timeout 300 tcpdump -i eth0 -w /root/output/loot/intern/network/passive.pcap' ENTER
tmux last-window
