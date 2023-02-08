#!/bin/bash
figlet ProSecDNSenum

echo "this could take some time!"

#request Nameserver IP
read -p -r "Customer INTERNAL DNS Server IP no subnetmask: " NS

#Private IP range
echo "10.0.0.0/8
172.16.0.0/12
192.168.0.0/16" >/root/input/privip.txt

#runtime
echo 'Start DNS Enum' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

#IP Networks via DNS
nmap -sL --dns-servers "$NS" -iL /root/input/privip.txt -oN /root/output/nmap/dns.nmap >/dev/null 2>&1

#make input file for auto_pt
awk '/\(1/ {print$6}' /root/output/nmap/dns.nmap | sed 's/[()]//g' >/root/output/list/dnsup.txt
if [ -s /root/input/ipint.txt ]; then
  cut -d . -f 1,2,3 /root/output/list/dnsup.txt | sort -u | sed 's/$/.0\/24/' >/root/input/ipint.txt
else
  cut -d . -f 1,2,3 /root/output/list/dnsup.txt | sort -u | sed 's/$/.0\/24/' >/root/input/dnsipint.txt
fi

echo 'END DNS Enum' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

exit 0