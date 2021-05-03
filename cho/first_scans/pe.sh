#!/bin/bash
net=$(echo $1 | awk -F \/ '{print$1}')
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 -oA pe_$net $1
awk '/Up/ {print$2}' pe_$net.gnmap > ips_$net.txt
nmap -sSV -Pn --scan-delay 1 --max-retries 2 --max-hostgroup 20 --host-timeout 5m -oA service_$net -iL ips_$net.txt

