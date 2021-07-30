#!/bin/bash

echo ''
echo "  _____           _____                         _        _____       _       _ _   "
echo " |  __ \         / ____|             /\        | |      / ____|     | |     (_) |  "
echo " | |__) | __ ___| (___   ___  ___   /  \  _   _| |_ ___| (___  _ __ | | ___  _| |_ "
echo " |  ___/ '__/ _ \\\\\___ \ / _ \/ __| / /\ \| | | | __/ _ \\\\\___ \| '_ \| |/ _ \| | __|"
echo " | |   | | | (_) |___) |  __/ (__ / ____ \ |_| | || (_) |___) | |_) | | (_) | | |_ "
echo " |_|   |_|  \___/_____/ \___|\___/_/    \_\__,_|\__\___/_____/| .__/|_|\___/|_|\__|"
echo "                                                              | |                  "
echo "                                                              |_|                  "
echo  ''

if [ -s /opt/hacking/dfi/resource.txt ]; then
    echo '! > resource.txt check OK'
else
    echo '! > resource.txt missing here: /opt/hacking/dfi'
    exit 1
fi

IP=$(ip addr show eth0 | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6)
#echo '! >> own IP eth0: '$IP

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf -a -d /root/output/loot/hashes ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf /root/output/loot/hashes
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

# Check for SHD_MANAGER
if grep -Fxq SHD_MANAGER /usr/share/metasploit-framework/data/wordlists/ipmi_users.txt; then
   echo '! > SHD_Manager exists'
else
   echo 'SHD_MANAGER' > /usr/share/metasploit-framework/data/wordlists/ipmi_users.txt
fi

echo '! > Start Metasploit Framework'
msfconsole -qx "resource /root/input/msf/workspace.txt resource /opt/hacking/dfi/resource.txt" > /dev/null
echo '! > MSF Done!'

