#!/bin/bash

figlet DNSrecon

{
  echo "DNSrecon"
  date
} >>/root/output/runtime.txt

# DNS Zone Transfer
echo "DNSrecon"
for i in $(cat /root/output/list/domainname.txt); do
  for j in $(cat /root/output/list/dc_ip.txt); do
    dnsrecon -d "$i" -n "$j" >>/root/output/loot/dns/recon_"$j".txt 2>&1
  done
done

{
  echo "DNS Zone Transfer"
  date
} >>/root/output/runtime.txt

# DNS Zone Transfer
echo "DNS Zone Transfer"
for i in $(cat /root/output/list/domainname.txt); do
  for j in $(cat /root/output/list/dc_ip.txt); do
    dig axfr "$i" @"$j" >>/root/output/loot/dns/zone_transfer/"$i".txt 2>&1
  done
done

{
  echo "END DNS Recon"
  date
} >>/root/output/runtime.txt
echo "END DNS Recon"
