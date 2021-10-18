#!/bin/bash
figlet ProSecAutoPT
echo ''

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

read -p "Enter Workspace Name: " WS
echo 'workspace -d ' $WS > /root/input/msf/workspace.txt
echo 'workspace -a ' $WS >> /root/input/msf/workspace.txt
echo 'workspace ' $WS >> /root/input/msf/ws.txt
echo 'db_import /root/output/nmap/service.xml' >> /root/input/msf/workspace.txt

tmux rename-window 'AUTO_PT'

echo "Start auto_PT" > /root/output/runtime.txt
date >> /root/output/runtime.txt
echo '! > Start Active Recon'
/opt/hacking/dfi/active_recon.sh

echo "Start autosploit" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

echo '! > Start Metasploit'
/opt/hacking/dfi/autosploit.sh

echo "Start zerocheck" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

echo '! > Start Zerocheck'
/opt/hacking/dfi/zerocheck.sh

echo "Start fast_relay" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

echo '! > Start Relay'
/opt/hacking/dfi/fast_relay.sh

echo "Start Eyewitness" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

echo '! > make some Screens'
/opt/hacking/dfi/eyewitness.sh

echo "Start lootcollector" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

echo "! > grab the loot!"
/opt/hacking/dfi/looter.sh

echo '! > PT Done xD'

echo "Finish PT" >> /root/output/runtime.txt
date >> /root/output/runtime.txt
