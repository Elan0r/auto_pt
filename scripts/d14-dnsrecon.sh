#!/bin/bash

figlet DNSrecon

#DNS
echo "DNSrecon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
# DNS Zone Transfer
echo "DNSrecon"
for i in $(cat /root/output/list/domainname.txt); do
  for j in $(cat /root/output/list/dc_ip.txt); do
    dnsrecon -d "$i" -n "$j" >>/root/output/loot/intern/dns/recon_"$j".txt 2>&1
  done
done

echo "DNS Zone Transfer" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
# DNS Zone Transfer
echo "DNS Zone Transfer"
for i in $(cat /root/output/list/domainname.txt); do
  for j in $(cat /root/output/list/dc_ip.txt); do
    dig axfr "$i" @"$j" >>/root/output/loot/intern/dns/zone_transfer/"$i".txt 2>&1
  done
done

echo "END DNS Recon"
echo "END DNS Recon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
