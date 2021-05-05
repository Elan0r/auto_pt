#!/bin/bash

if [[ -s ./resource.txt ]; then
    echo 'resource.txt ist da'
else
    echo 'resource.txt fehlt hier: ' $PWD
    exit 1
fi

IP=$(ip addr show eth0 | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6)
echo 'eigene IP eth0: '$IP

if [[ -d /root/output/msf  && -d /root/input/msf ]]; then
    echo 'Ordner sind da!'
else    
    #Creating Output Folders
    mkdir -p /root/output/msf

    #create Input Folder
    mkdir -p /root/input/msf
fi

read -p "Workspace eingeben: " WS

echo $WS

echo "workspace -d $WS" > /root/input/msf/workspace.txt
echo "workspace -a $WS" >> /root/input/msf/workspace.txt
echo "db_import /root/output/nmap/service.xml" >> /root/input/msf/workspace.txt

msfconsole -x "resource ./resource.txt resource /root/input/msf/workspace.txt"
