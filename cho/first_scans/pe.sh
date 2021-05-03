#!/bin/bash
net=$(echo $1 | awk -F \/ '{print$1}')
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 -oA pe_$net $1
awk '/Up/ {print$2}' pe_$net.gnmap > ips_$net.txt
nmap -sSV -Pn --scan-delay 1 --max-retries 2 --max-hostgroup 20 --host-timeout 5m -oA service_$net -iL ips_$net.txt

awk '/135\/open/ {print$2}' services_$net.gnmap > rpc_open.txt
awk '/389\/open/ {print$3}' services_$net.gnmap | sed 's/(/''/' | sed 's/)/''/' > ldap_open.txt
awk '/88\/open/ {print$2}' services_$net.gnmap > kerberos_open.txt
awk '/445\open/ {print$2}' services_$net.gnmap > smb_open.txt

crackmapexec smb smb_open.txt --gen-relay-list smb_sign_off.txt

for i in $(cat rpc_open.txt); do echo rpc://$i; done > relay_rpc.txt
for i in $(cat ldap_open.txt); do echo ldaps://$i; done > relay_ldap.txt
for i in $(cat kerberos_open.txt); do echo dcsync://$i; done > relay_dcsync.txt
for i in $(cat smb_sign_off.txt); do echo smb://$i; done > relay_smb.txt

cat relay_rpc.txt relay_ldap.txt relay_dcsync.txt relay_smb.txt > relay_ALL.txt

