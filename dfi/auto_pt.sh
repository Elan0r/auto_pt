#!/bin/bash
echo -e ''
echo -e '  _____           _____                         _        _____ _______ '
echo -e ' |  __ \         / ____|             /\        | |      |  __ \__   __|'
echo -e ' | |__) | __ ___| (___   ___  ___   /  \  _   _| |_ ___ | |__) | | |   '
echo -e ' |  ___/ |__/ _ \\\___ \ / _ \/ __| / /\ \| | | | __/ _ \|  ___/  | |   '
echo -e ' | |   | | | (_) |___) |  __/ (__ / ____ \ |_| | || (_) | |      | |   '
echo -e ' |_|   |_|  \___/_____/ \___|\___/_/    \_\__,_|\__\___/|_|      |_|   '
echo -e ''

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf ]; then
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

tmux rename-window 'AUTO_PT'

echo 'Start Active Recon'
./active_recon.sh
echo 'Start Metasploit'
./msf.sh
echo 'Start Relay'
./relay.sh
echo 'make some Screens'
./eyewitness.sh
echo 'PT Done xD'
