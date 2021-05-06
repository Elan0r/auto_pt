#!/bin/bash

if [[[ -d /root/output/nmap && -d /root/output/list && -d /root/input/msf ]]]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf
    echo '! > Folder Created!'
fi

chmod +x ./active_recon.sh
chmod +x ./msf.sh
chmod +x ./relay.sh
chmod +x ./eyewitness.sh

echo 'Start Active Recon'
./active_recon.sh
echo 'Start Metasploit'
./msf.sh
echo 'Start Relay'
./relay.sh
echo 'make some Screens'
./eyewitness.sh
echo 'PT Done xD'
