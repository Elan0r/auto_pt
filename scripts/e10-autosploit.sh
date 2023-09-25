#!/bin/bash

figlet AutoSploit

if [ ! -s /opt/auto_pt/resources/resource.txt ]; then
  echo '! > resource.txt missing here: /opt/auto_pt/resources/'
  exit 1
fi

if [ ! -s /root/input/msf/workspace.txt ]; then
  echo '! > workspace.txt missing here: /root/input/msf/'
  echo '! > use the menu option O'
  exit 1
fi

{
  echo 'Start autosploit'
  date
} >>/root/output/runtime.txt

sudo -u "$(id -un 1000)" msfdb start
msfconsole -qx "resource /root/input/msf/workspace.txt /opt/auto_pt/resources/resource.txt" >/dev/null

{
  echo 'END Autosploit'
  date
} >>/root/output/runtime.txt
echo 'END Autosploit'
