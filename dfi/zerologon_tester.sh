#!/bin/bash

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -s /root/input/msf/ws.txt ]; then
    echo 'Workspace already set!'
else
    read -p "Enter Workspace Name: " WS
    echo 'workspace -a ' $WS > /root/input/msf/ws.txt
    echo 'hosts -c name,address -o /root/output/msf/zerohosts.txt' >> /root/input/msf/ws.txt
    echo 'exit' >> /root/input/msf/ws.txt
fi

msfconsole -qx "resource /root/input/msf/ws.txt" > /dev/null
awk '/\"/ {print}' /root/output/msf/zerohosts.txt | grep -v '""' | cut -d '"' -f 2,4 | sed 's/"/ /' > /root/output/list/zero.txt

if [ -d /opt/CVE-2020-1472 ]; then
    echo '! > No Download nessesary.'
else
    cd /opt
    git clone https://github.com/SecuraBV/CVE-2020-1472.git /opt/
    pip3 install -r /opt/CVE-2020-1472/requirements.txt
fi

if [ -s /root/output/list/zero.txt ]; then
    for i in /root/output/list/zero.txt do
        python3 /opt/CVE-2020-1472/zerologon_tester.py $i >> /root/output/msf/zerologon.txt
    done
    echo '! > Check Done!'
else
    echo '! > Check not possible no Targets /root/output/list/zero.txt'
