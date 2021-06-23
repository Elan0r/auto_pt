#!/bin/bash

echo -e '  _____           _____                         _        _____       _       _ _   '
echo -e ' |  __ \         / ____|             /\        | |      / ____|     | |     (_) |  '
echo -e ' | |__) | __ ___| (___   ___  ___   /  \  _   _| |_ ___| (___  _ __ | | ___  _| |_ '
echo -e ' |  ___/ |__/ _ \\\___ \ / _ \/ __| / /\ \| | | | __/ _ \\\___ \| |_ \| |/ _ \| | __|'
echo -e ' | |   | | | (_) |___) |  __/ (__ / ____ \ |_| | || (_) |___) | |_) | | (_) | | |_ '
echo -e ' |_|   |_|  \___/_____/ \___|\___/_/    \_\__,_|\__\___/_____/| .__/|_|\___/|_|\__|'
echo -e '                                                              | |                  '
echo -e '                                                              |_|                  '
echo -e ''

if [ -s /opt/hacking/dfi/resource.txt ]; then
    echo '! > resource.txt check OK'
else
    echo '! > resource.txt missing here: /opt/hacking/dfi'
    exit 1
fi

IP=$(ip addr show eth0 | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6)
#echo '! >> own IP eth0: '$IP

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -s /root/input/msf/workspace.txt ]; then
    echo 'Workspace already set!'
else
    read -p "Enter Workspace Name: " WS
    echo 'workspace -d ' $WS > /root/input/msf/workspace.txt
    echo 'workspace -a ' $WS >> /root/input/msf/workspace.txt
    echo 'db_import /root/output/nmap/service.xml' >> /root/input/msf/workspace.txt
fi

echo '! > Start Metasploit Framework'
msfconsole -qx "resource /root/input/msf/workspace.txt resource /opt/hacking/dfi/resource.txt" > /dev/null
echo '! > Done!'
