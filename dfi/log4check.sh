#!/bin/bash

figlet -w 104 ProSecLog4ShellCheck

echo '! > Log4J check via ETH0!'

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -s /opt/hacking/resource_script/log4j.txt ]; then
    echo '! > Log4J resource OK!'
else
    echo '! > log4j.txt resource missing here: /opt/hacking/resource_script/ !'
    exit 1
fi

echo "Start MSF Log4Shell check" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

msfconsole -qx "resource /root/input/msf/ws.txt /opt/hacking/resource_script/log4j.txt" > /dev/null
echo '! > Log4Shell Check Done!'

exit 0
