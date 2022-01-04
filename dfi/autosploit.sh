#!/bin/bash

figlet ProSecAutoSploit

if [ -s /opt/hacking/resource_script/resource.txt ]; then
    echo '! > resource.txt check OK'
else
    echo '! > resource.txt missing here: opt/hacking/resource_script/'
    exit 1
fi

if [ -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf -a -d /root/output/loot/hashes ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/input/msf /root/output/loot /root/output/msf /root/output/loot/hashes
    #echo '! > Folder Created!'
fi

if [ -s /root/input/msf/workspace.txt ]; then
    echo 'Workspace already set!'
else
    read -p "Enter Workspace Name: " WS
    echo 'workspace -d ' $WS > /root/input/msf/workspace.txt
    echo 'workspace -a ' $WS >> /root/input/msf/workspace.txt
    echo 'db_import /root/output/nmap/service.xml' >> /root/input/msf/workspace.txt
    #for Zerocheck
    echo 'workspace -a ' $WS > /root/input/msf/ws.txt
fi

# Check for SHD_MANAGER
if grep -Fxq SHD_MANAGER /usr/share/metasploit-framework/data/wordlists/ipmi_users.txt; then
   echo '! > SHD_Manager exists'
else
   echo 'SHD_MANAGER' > /usr/share/metasploit-framework/data/wordlists/ipmi_users.txt
fi

msfdb init
echo '! > Start Metasploit Framework'
msfconsole -qx "resource /root/input/msf/workspace.txt /opt/hacking/resource_script/resource.txt" > /dev/null
echo '! > MSF Done!'

exit 0
