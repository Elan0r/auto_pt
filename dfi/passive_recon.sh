#!/bin/bash

tmux new-session -d -s Passive-Recon
tmux send 'netdiscover -L -i eth0 > /root/output/netdiscover'
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -c' ENTER
tmux split-window
tmux send 'tail --follow /root/output/netdiscover' ENTER
