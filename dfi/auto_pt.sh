#!/bin/bash
echo -e ''
echo -e '  _____           _____                         _        _____ _______ '
echo -e ' |  __ \         / ____|             /\        | |      |  __ \__   __|'
echo -e ' | |__) | __ ___| (___   ___  ___   /  \  _   _| |_ ___ | |__) | | |   '
echo -e ' |  ___/ |__/ _ \\\___ \ / _ \/ __| / /\ \| | | | __/ _ \|  ___/  | |   '
echo -e ' | |   | | | (_) |___) |  __/ (__ / ____ \ |_| | || (_) | |      | |   '
echo -e ' |_|   |_|  \___/_____/ \___|\___/_/    \_\__,_|\__\___/|_|      |_|   '
echo -e ''

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
echo 'db_import /root/output/nmap/service.xml' >> /root/input/msf/workspace.txt

chmod +x /opt/hacking/dfi/*.sh

tmux rename-window 'AUTO_PT'

echo 'Start Active Recon'
/opt/hacking/dfi/active_recon.sh
echo 'Start Metasploit'
/opt/hacking/dfi/autosploit.sh
echo 'Start Relay'
/opt/hacking/dfi/fast_relay.sh
echo 'make some Screens'
/opt/hacking/dfi/eyewitness.sh
echo 'PT Done xD'
