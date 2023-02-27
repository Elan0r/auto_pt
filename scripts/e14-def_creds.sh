#!/bin/bash

figlet ProSecDefCreds

#Root login check
if [ -s /root/output/nmap/ssh.nmap ]; then
  echo '! >> SSH ROOT login Scan already Done'
else
  echo '! > Checking SSH Root login'
  nmap -Pn -n -p 22 --script ssh-auth-methods --script-args="ssh.user=root" -iL /root/output/list/ssh_open.txt -oA /root/output/nmap/ssh >/dev/null 2>&1 &
fi

#NMAP default-creds
if [ -s /root/output/nmap/default-creds.nmap ]; then
  echo '! > Default-Creds test already done!'
else
  echo '! > Default-Creds Background Job start!'
  nmap -e eth0 -n -oA /root/output/nmap/default-creds -iL /root/output/list/ipup.txt -p 80,443,8080,8443 --script http-default-accounts --script-args http-default-accounts.fingerprintfile=/opt/nndefaccts/http-default-accounts-fingerprints-nndefaccts.lua >/dev/null 2>&1 &
fi

echo 'END Def_Creds Check' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

exit 0
