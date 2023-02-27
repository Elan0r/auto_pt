#!/bin/bash

figlet ProSecAutoPT
echo 'version 1.7 '

if [ -s /root/input/ipint.txt ]; then
  echo '! > IPs OK '
else
  echo '! >> ipint.txt is missing in /root/input/ipint.txt.'
  exit 1
fi

#Create all folder
/opt/auto_pt/scripts/b10-folder.sh

read -r -p "Enter Workspace Name: " WS
echo 'workspace -d ' "$WS" >/root/input/msf/workspace.txt
echo 'workspace -a ' "$WS" >>/root/input/msf/workspace.txt
echo 'workspace ' "$WS" >/root/input/msf/ws.txt
echo 'db_import /root/output/nmap/service.xml' >>/root/input/msf/workspace.txt

tmux rename-window 'Auto_PT'

echo 'Start Auto_PT' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo '! > Start Active Recon'
/opt/auto_pt/scripts/d11-active_recon.sh

echo '! > Start Metasploit'
/opt/auto_pt/scripts/e10-autosploit.sh

echo '! > Start Zerocheck'
/opt/auto_pt/scripts/e11-zerocheck.sh

echo '! > Start Log4Check'
/opt/auto_pt/scripts/e12-log4check.sh

echo '! > Start RPC 0 Check'
/opt/auto_pt/scripts/e13-rpc0check.sh

echo '! > Start def_creds Check'
/opt/auto_pt/scripts/e14-def_creds.sh

echo '! > Start SSL Check'
/opt/auto_pt/scripts/e15-sslscan.sh

echo '! > Start RelayList Creation'
/opt/auto_pt/scripts/e16-relaylist.sh

echo '! > Start Relay'
/opt/auto_pt/scripts/f10-fast_relay.sh

echo "! > grab the loot!"
/opt/auto_pt/scripts/g10-looter.sh

echo "! > Count the Loot!"
/opt/auto_pt/scripts/h10-counter.sh

echo '! > make some Screens'
/opt/auto_pt/scripts/i10-eyewitness.sh

echo '! > loot and count default Pages'
/opt/auto_pt/scripts/j10-def_screen_looter.sh

figlet 'Auto PT Done'

echo "Finish PT" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

exit 0
