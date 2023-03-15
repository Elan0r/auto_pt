#!/bin/bash

figlet -w 87 ProSecActiveRecon

if [ -s /root/input/ipint.txt ]; then
  echo '! > IPs OK '
else
  echo "! >> ipint.txt is missing in /root/input/ipint.txt."
  exit 1
fi

echo "Start ActiveRecon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

#NMAP portquiz.net -> egress filter
if [ -s /root/output/nmap/egress.nmap ]; then
  echo 'Egress Filter Test already Done!'
else
  echo 'Egress Filter Background Job start!'
  nmap -e eth0 -oA /root/output/nmap/egress portquiz.net >/dev/null 2>&1 &
fi

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
  echo 'nmap PE already Done!'
else
  echo 'NMAP PE Scan  FAST'

  echo "Start PE Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -PE -sn -n --max-retries 2 -oA /root/output/nmap/pe -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap | sort -u >/root/output/list/ip_pe_up.txt
fi

#NMAP IP Protocol scan
if [ -s /root/output/nmap/ip_protocol.gnmap ]; then
  echo 'IP protocol nmap already Done!'
else
  echo 'NMAP sO IP Protocolscan'

  echo "Start IP Protocol Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -sO --version-intensity 0 --host-timeout 10s --max-retries 2 --min-hostgroup 64 -oA /root/output/nmap/ip_protocol -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/ip_protocol.gnmap | sort -u >/root/output/list/ip_proto_up.txt
fi

cat /root/output/list/ip_proto_up.txt /root/output/list/ip_pe_up.txt | sort -u >/root/output/list/ipup.txt

#NMAP Service Scan
if [ -s /root/output/nmap/service.gnmap ]; then
  echo 'SERVICE nmap already Done!'
else
  echo 'NMAP SSV   SLOW!'

  echo "Start Service Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -sSV -defeat-rst-ratelimit -n -Pn --max-retries 5 -oA /root/output/nmap/service -iL /root/output/list/ipup.txt >/dev/null 2>&1
fi

echo 'END active_recon' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END active_recon'
