#!/bin/bash

figlet ProSecRelayLists

if [ -s /root/output/list/smb_sign_off.txt ]; then
  echo '! >> RELAY LIST EXISTS'
else
  echo '! > BUILDING CME SMB RELAY LIST'

  echo "Start CME build Relay List" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  #Using Crackmap to Check which of the IP's with 445 open have Signing:false
  crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >/root/output/cme_beauty.txt 2>&1
fi

#Create Relay LISTs
for i in $(cat /root/output/list/rpc_open.txt); do
  echo rpc://"$i" >>/root/output/list/relay_rpc.txt
done

for i in $(cat /root/output/list/ldap_open.txt); do
  echo ldaps://"$i" >>/root/output/list/relay_ldap.txt
done

for i in $(cat /root/output/list/kerberos_open.txt); do
  echo dcsync://"$i" >>/root/output/list/relay_dcsync.txt
done

for i in $(cat /root/output/list/smb_sign_off.txt); do
  echo smb://"$i" >>/root/output/list/relay_smb.txt
done

cat /root/output/list/relay* >/root/output/list/relay_all.txt

echo 'END RelayList Creation' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
