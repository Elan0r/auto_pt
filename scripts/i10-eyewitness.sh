#!/bin/bash

if [ -d /root/output/screens ]; then
  echo '! > Folder exist; mv screens screens_old for Backup purpose!'
  mv /root/output/screens /root/output/screens_old
  mkdir -p /root/output/screens
else
  #Creating Output Folders
  mkdir -p /root/output/screens
fi
if [ ! -s /usr/lib/python3/dist-packages/selenium/webdriver/firefox/webdriver_prefs.json ]; then
  cp /opt/auto_pt/resources/webdriver_prefs.json /usr/lib/python3/dist-packages/selenium/webdriver/firefox/
fi

{
  echo 'Start Eyewitness'
  date
} >>/root/output/runtime.txt

eyewitness --web --timeout 20 --delay 20 --no-prompt --prepend-https -x /root/output/nmap/service.xml -d /root/output/screens/

{
  echo 'END Eyewitness'
  date
} >>/root/output/runtime.txt
echo 'END Eyewitness'

{
  echo 'Start Scrying'
  date
} >>/root/output/runtime.txt

timeout 300 /opt/scrying/scrying -s -f /root/output/list/scrying_rdp.txt -o /root/output/scrying/rdp -m rdp -l /root/output/scrying/rdp/log.txt
timeout 300 /opt/scrying/scrying -s -f /root/output/list/scrying_vnc.txt -o /root/output/scrying/vnc -m vnc -l /root/output/scrying/vnc/log.txt

{
  echo 'END Scrying'
  date
} >>/root/output/runtime.txt
echo 'END Scrying'
