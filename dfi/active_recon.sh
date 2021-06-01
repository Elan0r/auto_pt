#!/bin/bash

echo '  _____           _____                        _   _           _____                      '
echo ' |  __ \         / ____|             /\       | | (_)         |  __ \                     '
echo ' | |__) | __ ___| (___   ___  ___   /  \   ___| |_ ___   _____| |__) |___  ___ ___  _ __  '
echo ' |  ___/ |__/ _ \\___ \ / _ \/ __| / /\ \ / __| __| \ \ / / _ \  _  // _ \/ __/ _ \| |_ \ '
echo ' | |   | | | (_) |___) |  __/ (__ / ____ \ (__| |_| |\ V /  __/ | \ \  __/ (_| (_) | | | |'
echo ' |_|   |_|  \___/_____/ \___|\___/_/    \_\___|\__|_| \_/ \___|_|  \_\___|\___\___/|_| |_|'
echo ''

#echo '! > Networks to scan in /root/input/ipint.txt for nmap'
#echo '' 
if [ -s /root/input/ipint.txt ]; then
    echo '! > IPs OK '
else
    echo "! >> ipint.txt is missing in /root/input/ipint.txt."
	exit 1
fi


if [[ -d /root/output/nmap && -d /root/output/list ]]; then
    echo ' '
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list
fi

#NMAP PE SCAN
echo '! > NMAP PE Scan    FAST'
if [ -s /root/output/list/ipup.txt ]; then
echo '! >> nmap PE already Done!'
else
   nmap -e eth0 -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/ipint.txt > /dev/null 2>&1
   echo ''
   echo '! > Done'

   #Piping the IP-Addresses of the Targets to a file
   awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap > /root/output/list/ipup.txt
   echo ''
fi

#NMAP SSV SC Alles
echo '! > NMAP SSV SC   SLOW!'

nmap -e eth0 -sSV -sC -Pn --scan-delay 1 --max-hostgroup 20 -oA /root/output/nmap/service -iL /root/output/list/ipup.txt > /dev/null 2>&1
echo '! > Done'
echo ''

#echo 'File Splitt in Service LISTEN'

awk '/135\/open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/rpc_open.txt
awk '/389\/open/ {print$3}' /root/output/nmap/service.gnmap | sed 's/(/''/' | sed 's/)/''/' > /root/output/list/ldap_open.txt
awk '/88\/open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/kerberos_open.txt
awk '/445\/open/ {print$2}' /root/output/nmap/service.gnmap > /root/output/list/smb_open.txt

#echo 'Done'
echo ''
echo '! > BUILDING CME SMB RELAY LIST'
if [ -s /root/output/list/smb_sign_off.txt ]; then
   echo '! >> RELAY LIST EXISTS'
else
   #Using Crackmap to Check which of the IP's with 445 open have Signing:false
   #echo 'Generating Relay List'
   crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt > /root/output/cme_beauty.txt
   echo '! > Done'
fi

#echo 'done'

#echo ''
#echo 'Erstelle Relay LISTEN'

for i in $(cat /root/output/list/rpc_open.txt); do echo rpc://$i; done > /root/output/list/relay_rpc.txt
for i in $(cat /root/output/list/ldap_open.txt); do echo ldaps://$i; done > /root/output/list/relay_ldap.txt
for i in $(cat /root/output/list/kerberos_open.txt); do echo dcsync://$i; done > /root/output/list/relay_dcsync.txt
for i in $(cat /root/output/list/smb_sign_off.txt); do echo smb://$i; done > /root/output/list/relay_smb.txt

#echo 'Done'
#echo ''
echo 'Create Relay_ALL LIST'

cat /root/output/list/relay* > /root/output/list/relay_all.txt

echo 'Done'
