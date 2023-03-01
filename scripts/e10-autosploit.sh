#!/bin/bash

figlet ProSecAutoSploit

if [ -s /opt/auto_pt/resources/resource.txt ]; then
  echo '! > resource.txt check OK'
else
  echo '! > resource.txt missing here: /opt/auto_pt/resources/'
  exit 1
fi

# Check for SHD_MANAGER
if grep -Fxq SHD_MANAGER /usr/share/metasploit-framework/data/wordlists/ipmi_users.txt; then
  echo '! > SHD_Manager exists'
else
  echo 'SHD_MANAGER' >>/usr/share/metasploit-framework/data/wordlists/ipmi_users.txt
fi

if [ -s /root/input/msf/workspace.txt ]; then
  echo 'Workspace already set!'
else
  read -r -p "Enter Workspace Name: " WS
  echo 'workspace -d ' "$WS" >/root/input/msf/workspace.txt
  echo 'workspace -a ' "$WS" >>/root/input/msf/workspace.txt
  echo 'db_import /root/output/nmap/service.xml' >>/root/input/msf/workspace.txt
  #for Zerocheck
  echo 'workspace -a ' "$WS" >/root/input/msf/ws.txt
fi

echo 'Start autosploit' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

msfdb init
echo '! > Start Metasploit Framework'
msfconsole -qx "resource /root/input/msf/workspace.txt /opt/auto_pt/resources/resource.txt" >/dev/null
echo '! > MSF Done!'

echo 'END Autosploit' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
