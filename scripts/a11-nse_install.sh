#!/bin/bash

cp /opt/auto_pt/resources/*.nse /usr/share/nmap/scripts/

#vulscan
if [ -d /opt/nmap-vulners ]; then
  cd /opt/nmap-vulners || ! echo "Failure"
  git stash
  git pull
else
  cd /opt || ! echo "Failure"
  git clone https://github.com/vulnersCom/nmap-vulners.git
fi
cp /opt/nmap-vulners/vulners.nse /usr/share/nmap/scripts/
cp /opt/nmap-vulners/http-vulners-regex.nse /usr/share/nmap/scripts/
cp /opt/nmap-vulners/http-vulners-regex.json /usr/share/nmap/nselib/data/
cp /opt/nmap-vulners/http-vulners-paths.txt /usr/share/nmap/nselib/data/

wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/proconos-info.nse -O /usr/share/nmap/scripts/proconos-info.nse
wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/pcworx-info.nse -O /usr/share/nmap/scripts/pcworx-info.nse
wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/BACnet-discover-enumerate.nse -O /usr/share/nmap/scripts/BACnet-discover-enumerate.nse
wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/codesys-v2-discover.nse -O /usr/share/nmap/scripts/codesys-v2-discover.nse

nmap --script-updatedb
