#!/bin/bash

figlet ProSecZeroCheck

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -s /root/output/list/zero.txt ]; then
    echo '! > list zero.txt available!'
else

    if [ -s /root/input/msf/ws.txt ]; then
        echo '! >Workspace already set!'
    else
        read -p "Enter Workspace Name: " WS
        echo 'workspace -a ' $WS > /root/input/msf/ws.txt
    fi
    
    echo 'hosts -S Windows -c name,address -o /root/output/msf/zerohosts.txt' > /root/input/msf/zerohosts.txt
    echo 'exit' >> /root/input/msf/zerohosts.txt
    
    msfconsole -qx "resource /root/input/msf/ws.txt resource /root/input/msf/zerohosts.txt"
    awk '/"/ {print}' /root/output/msf/zerohosts.txt | grep -v '""' | cut -d '"' -f 2,4 | sed 's/"/ /' > /root/output/list/zero.txt
fi

printf '%sspool /root/output/msf/zerologon.txt\necho "ZeroLogon"\nuse auxiliary/admin/dcerpc/cve_2020_1472_zerologon\n' > /root/input/msf/zerologon.txt
awk '// {printf"\nset nbname "$1"\nset rhosts "$2"\ncheck\n"}' /root/output/list/zero.txt >> /root/input/msf/zerologon.txt
printf '%s\nexit\n' >> /root/input/msf/zerologon.txt
msfconsole -qx "resource /root/input/msf/ws.txt resource /root/input/msf/zerologon.txt"
echo '! > Check Done!'

exit 0
