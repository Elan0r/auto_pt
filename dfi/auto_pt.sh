#!/bin/bash
figlet ProSecAutoPT
echo 'version 1.3'

if [ -s /root/input/ipint.txt ]; then
    echo '! > IPs OK '
else
    echo "! >> ipint.txt is missing in /root/input/ipint.txt."
	exit 1
fi

#Create all folder
/opt/hacking/dfi/folder.sh

read -p "Enter Workspace Name: " WS
echo 'workspace -d ' $WS > /root/input/msf/workspace.txt
echo 'workspace -a ' $WS >> /root/input/msf/workspace.txt
echo 'workspace ' $WS > /root/input/msf/ws.txt
echo 'db_import /root/output/nmap/service.xml' >> /root/input/msf/workspace.txt

tmux rename-window 'AUTO_PT'

echo "Start auto_PT" > /root/output/runtime.txt
date >> /root/output/runtime.txt
echo '! > Start Active Recon'
/opt/hacking/dfi/active_recon.sh

echo '! > Start Metasploit'
/opt/hacking/dfi/autosploit.sh

echo '! > Start Zerocheck'
/opt/hacking/dfi/zerocheck.sh

echo '! > Start Log4Check'
/opt/hacking/dfi/log4check.sh

echo '! > Start RPC 0 Check'
/opt/hacking/dfi/rpc0.sh

echo '! > Start Relay'
/opt/hacking/dfi/fast_relay.sh

echo '! > make some Screens'
/opt/hacking/dfi/eyewitness.sh

echo "! > grab the loot!"
/opt/hacking/dfi/looter.sh

echo "! > Count the Loot!"
/opt/hacking/dfi/counter.sh

figlet 'Auto PT Done'

echo "Finish PT" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

exit 0
