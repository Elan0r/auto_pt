#!/bin/bash

echo 'Netze zum scannen in /root/ipint.txt fuer nmap'
echo '' 
if [ -s /root/ipint.txt ]; then
    echo "ipint.txt ist da."
else 
    echo "ipint.txt existiert nicht oder ist leer."
	exit 1
fi


#Creating Output Folders
mkdir -p /root/output/nmap /root/output/list 

#NMAP PE SCAN

echo 'NMAP PE Scan'
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/pe -iL /root/ipint.txt > /dev/null 2>&1
echo ''
echo 'Done'

awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap > /root/output/list/ipup.txt

#NMAP SSV SC Alles
echo 'nmap ssv sc'

nmap -sSV -sC -Pn --scan-delay 1 --max-retries 2 --max-hostgroup 20 --host-timeout 5m -oA /root/output/nmap/service -iL /root/output/list/ipup.txt > /dev/null 2>&1
echo 'Done'
echo ''

echo 'File Splitt in Service LISTEN'

awk '/135\/open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/rpc_open.txt
awk '/389\/open/ {print$3}' /root/output/nmap/service.gnmap | sed 's/(/''/' | sed 's/)/''/' > /root/output/list/ldap_open.txt
awk '/88\/open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/kerberos_open.txt
awk '/445\open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/smb_open.txt

echo 'Done'
echo ''
echo 'cme SMB Signing relay LISTE'

crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt > /root/output/cme_beauty.txt

echo 'done'

echo ''
echo 'Erstelle Relay LISTEN'

for i in $(cat /root/output/list/rpc_open.txt); do echo rpc://$i; done > /root/output/list/relay_rpc.txt
for i in $(cat /root/output/list/ldap_open.txt); do echo ldaps://$i; done > /root/output/list/relay_ldap.txt
for i in $(cat /root/output/list/kerberos_open.txt); do echo dcsync://$i; done > /root/output/list/relay_dcsync.txt
for i in $(cat /root/output/list/smb_sign_off.txt); do echo smb://$i; done > /root/output/list/relay_smb.txt

echo 'Done'
echo ''
echo 'merge relay ALL LISTE'

cat /root/output/list/relay* > /root/output/list/relay_all.txt

echo 'Done'
