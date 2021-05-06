#!/bin/bash

if [[[ -d /root/output/nmap && -d /root/output/list && -d /root/input/msf ]]]; then
    echo 'Ordner sind da!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf
fi

tmux -f dfitmux.conf new-session -d
tmux rename-window 'Passive-Recon'
tmux send 'netdiscover -L -i eth0 > /root/output/netdiscover' ENTER
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -c' ENTER
tmux split-window
tmux send 'tail --follow /root/output/netdiscover' ENTER
