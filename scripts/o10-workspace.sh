#!/bin/bash

figlet MSFWorkspace

read -r -p "Enter Workspace Name: " WS
echo 'workspace -a ' "$WS" >/root/input/msf/workspace.txt
echo 'db_import /root/output/nmap/service.xml' >>/root/input/msf/workspace.txt
#for Zerocheck
echo 'workspace -a ' "$WS" >/root/input/msf/ws.txt

figlet 'Workspace Set'
