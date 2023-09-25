#!/bin/bash

figlet ActiveRecon

if [ ! -s /root/input/ipint.txt ]; then
  echo "! >> ipint.txt is missing in /root/input/ipint.txt."
  exit 1
fi

{
  echo "Start ActiveRecon"
  date
} >>/root/output/runtime.txt

#NMAP portquiz.net -> egress filter
if [ ! -s /root/output/nmap/egress.nmap ]; then
  echo 'Egress Filter Background Job start!'
  nmap -e eth0 -oA /root/output/nmap/egress portquiz.net >/dev/null 2>&1 &
fi

#NMAP PE SCAN
if [ ! -s /root/output/list/ipup.txt ]; then
  {
    echo "Start PE Scan"
    date
  } >>/root/output/runtime.txt
  echo 'NMAP PE Scan  FAST'
  nmap -e eth0 -PE -sn -n --disable-arp-ping --min-parallelism 32 --max-retries 2 --max-scan-delay 5ms --host-timeout 10s --max-rtt-timeout 1500ms --min-hostgroup 64 -oA /root/output/nmap/pe -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap | sort -u >/root/output/list/ip_pe_up.txt
fi

#NMAP IP Protocol scan
if [ ! -s /root/output/nmap/ip_protocol.gnmap ]; then
  {
    echo "Start IP Protocol Scan"
    date
  } >>/root/output/runtime.txt
  echo 'NMAP sO IP Protocolscan'
  nmap -e eth0 -sO -n --disable-arp-ping --version-intensity 0 --min-parallelism 32 --max-retries 2 --max-scan-delay 5ms --host-timeout 20s --max-rtt-timeout 1500ms --min-hostgroup 64 -oA /root/output/nmap/ip_protocol -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/ip_protocol.gnmap | sort -u >/root/output/list/ip_proto_up.txt
fi

cat /root/output/list/ip_proto_up.txt /root/output/list/ip_pe_up.txt | sort -u >/root/output/list/ipup.txt

#NMAP Service Scan
if [ ! -s /root/output/nmap/service.gnmap ]; then
  {
    echo "Start Service Scan"
    date
  } >>/root/output/runtime.txt
  echo 'NMAP SSV   SLOW!'
  nmap -e eth0 -sSV -n --disable-arp-ping -Pn --top-ports 500 -defeat-rst-ratelimit --min-parallelism 32 --max-retries 2 --max-scan-delay 5ms --host-timeout 180s --max-rtt-timeout 1500ms --min-hostgroup 64 -oA /root/output/nmap/service -iL /root/output/list/ipup.txt >/dev/null 2>&1
fi

{
  echo 'END active_recon'
  date
} >>/root/output/runtime.txt
echo 'END active_recon'
