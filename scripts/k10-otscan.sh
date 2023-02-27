#!/bin/bash

figlet ProSecOTScan

if [ -s /root/input/ipot.txt ]; then
  echo '! > IPs OK '
else
  echo "! >> ipot.txt is missing in /root/input/ipot.txt."
  exit 1
fi

echo "Update nmap scripts" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

if [ ! -s /usr/share/nmap/scripts/proconos-info.nse ]; then
  wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/proconos-info.nse -O /usr/share/nmap/scripts/proconos-info.nse
fi

if [ ! -s /usr/share/nmap/scripts/pcworx-info.nse ]; then
  wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/pcworx-info.nse -O /usr/share/nmap/scripts/pcworx-info.nse
fi

if [ ! -s /usr/share/nmap/scripts/BACnet-discover-enumerate.nse ]; then
  wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/BACnet-discover-enumerate.nse -O /usr/share/nmap/scripts/BACnet-discover-enumerate.nse
fi

if [ ! -s /usr/share/nmap/scripts/codesys-v2-discover.nse ]; then
  wget https://raw.githubusercontent.com/digitalbond/Redpoint/master/codesys-v2-discover.nse -O /usr/share/nmap/scripts/codesys-v2-discover.nse
fi

nmap --script-updatedb

echo "Start OT discover" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

nmap -Pn -sT --scan-delay 1s --max-parallelism 1 -p 80,102,443,502,530,593,789,1089-1091,1200,1911,1962,2222,2404,2455,4000,4840,4843,4911,9600,19999,20000,20547,34962-34964,34980,4481,46823,44824,55000-55003 -oA /root/output/nmap/ot/discover -iL /root/output/list/ipup.txt
nmap -Pn -sU --scan-delay 1s --max-parallelism 1 -p 47808,44818 -oA /root/output/nmap/ot/discover.udp -iL /root/output/list/ipup.txt

awk '/102\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/simatic.txt
awk '/502\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/modbus.txt
awk '/47808\/open/ {print$2}' /root/output/nmap/ot/discover.udp.gnmap | sort -u >/root/output/list/ot/bacnet.txt
awk '/44818\/open/ {print$2}' /root/output/nmap/ot/discover.udp.gnmap | sort -u >/root/output/list/ot/enip.txt
awk '/1911\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/niagara.txt
awk '/4911\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >>/root/output/list/ot/niagara.txt
awk '/20547\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/proconos.txt
awk '/9600\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/omron.txt
awk '/1962\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/pcworx.txt
awk '/46824\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/hmi.txt
awk '/1200\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >/root/output/list/ot/codesys.txt
awk '/2455\/open/ {print$2}' /root/output/nmap/ot/discover.gnmap | sort -u >>/root/output/list/ot/codesys.txt

echo "Start OTScan" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

nmap -Pn -sT -p 46824 -iL /root/output/list/ot/hmi.txt -oA /root/output/nmap/ot/hmi
nmap -PN -sT -p 102 --script s7-info -iL /root/output/list/ot/simatic.txt -oA /root/output/nmap/ot/simatic
nmap -Pn -sT -p 502 --script modbus-discover -iL /root/output/list/ot/modbus.txt -oA /root/output/nmap/ot/modbus
nmap -Pn -sT -p 502 --script modbus-discover --script-args='modbus-discover.aggressive=true' -iL /root/output/list/ot/modbus.txt -oA /root/output/nmap/ot/modbus.ag
nmap -Pn -sU -p 47808 --script bacnet-info -iL /root/output/list/ot/bacnet.txt -oA /root/output/nmap/ot/bacnet
nmap -Pn -sU -p 44818 --script enip-info -iL /root/output/list/ot/enip.txt -oA /root/output/nmap/ot/enip
nmap -Pn -sT -p 1911,4911 --script fox-info -iL /root/output/list/ot/niagara.txt -oA /root/output/nmap/ot/niagara
nmap -Pn -sT -p 20547 --script proconos-info -iL /root/output/list/ot/proconos.txt -oA /root/output/nmap/ot/proconos
nmap -Pn -sT -p 9600 --script omron-info -iL /root/output/list/ot/omron.txt -oA /root/output/nmap/ot/omron
nmap -Pn -sU -p 9600 --script omron-info -iL /root/output/list/ot/omron.txt -oA /root/output/nmap/ot/omron.udp
nmap -Pn -sT -p 1962 --script pcworx-info -iL /root/output/list/ot/pcworx.txt -oA /root/output/nmap/ot/pcworx
nmap -Pn -sU -p 47808 --script BACnet-discover-enumerate --script-args full=yes -iL /root/output/list/ot/bacnet.txt -oA /root/output/nmap/ot/bacnet.enum
nmap -Pn -sT -p 1200,2455 --script codesys-v2-discover -iL /root/output/list/ot/codesys.txt -oA /root/output/nmap/ot/codesys

echo "Finished OTScan"
echo "END OTScan" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

exit 0
