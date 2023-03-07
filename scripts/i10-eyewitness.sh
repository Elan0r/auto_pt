#!/bin/bash

if [ -d /root/output/screens ]; then
  echo '! > Folder exist; mv screens screens_old for Backup purpose!'
  mv /root/output/screens /root/output/screens_old
  mkdir -p /root/output/screens
else
  #Creating Output Folders
  mkdir -p /root/output/screens
fi
if [ -s /usr/lib/python3/dist-packages/selenium/webdriver/firefox/webdriver_prefs.json ]; then
  echo '!> webdriver_prefs.json present!'
else
  cp /opt/auto_pt/resources/webdriver_prefs.json /usr/lib/python3/dist-packages/selenium/webdriver/firefox/
  echo '!> webdriver_prefs.json copied!'
fi

echo 'Start Eyewitness' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

eyewitness --web --timeout 20 --delay 20 --no-prompt --prepend-https -x /root/output/nmap/service.xml -d /root/output/screens/

echo 'END Eyewitness' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END Eyewitness'
