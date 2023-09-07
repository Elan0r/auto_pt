#!/bin/bash

figlet AutoSploit

if [ -s /opt/auto_pt/resources/resource.txt ]; then
  echo '! > resource.txt check OK'
else
  echo '! > resource.txt missing here: /opt/auto_pt/resources/'
  exit 1
fi

echo 'Start autosploit' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

msfdb init
echo '! > Start Metasploit Framework'
msfconsole -qx "resource /root/input/msf/workspace.txt /opt/auto_pt/resources/resource.txt" >/dev/null
echo '! > MSF Done!'

echo 'END Autosploit' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END Autosploit'
