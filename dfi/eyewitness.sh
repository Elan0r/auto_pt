#!/bin/bash

if [ -d /root/output/screens ]]; then
    echo '! > Folder exist; mv screens screens_old for Backup purpose!'
    mv /root/output/screens /root/output/screens_old
    mkdir -p /root/output/screens
else    
    #Creating Output Folders
    mkdir -p /root/output/screens
    echo '! > Folder created!'
fi

eyewitness --web --timeout --delay 20 --no-prompt --prepend-https -x /root/output/nmap/service.xml -d /root/output/screens/
