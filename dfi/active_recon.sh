#!/bin/bash

echo 'Netze zum scannen in /root/ipint.txt fuer nmap'
echo '' 
if [ -s /root/ipint.txt ]; then
    echo "ipint.txt ist da."
else 
    echo "ipint.txt existiert nicht oder ist leer."
	exit 1
fi


if [[ -d /root/output/nmap && -d /root/output/list ]]; then
    echo 'Ordner sind da!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list
fi

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
echo 'nmap PE bereits gelaufen'
else
   echo 'NMAP PE Scan'
   nmap -e eth0 -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/ipint.txt > /dev/null 2>&1
   echo ''
   echo 'Done'

   #Piping the IP-Addresses of the Targets to a file
   awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap > /root/output/list/ipup.txt
   echo ''
fi

#NMAP SSV SC Alles
echo 'nmap ssv sc'

nmap -e eth0 -sSV -sC -Pn --scan-delay 1 --max-hostgroup 20 --host-timeout 10m -oA /root/output/nmap/service -iL /root/output/list/ipup.txt > /dev/null 2>&1
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
if [ -s /root/output/list/smb_sign_off.txt ]; then
   echo 'SMB Signing Liste schon da'
else
   #Using Crackmap to Check which of the IP's with 445 open have Signing:false
   echo 'Generating Relay List'
   crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt > /root/output/cme_beauty.txt
   echo 'Done'
fi

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
