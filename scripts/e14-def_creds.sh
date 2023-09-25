#!/bin/bash

figlet DefCreds

{
  echo 'SSH root login BG Task Check'
  date
} >>/root/output/runtime.txt

#Root login check
if [ ! -s /root/output/nmap/ssh.nmap ]; then
  nmap -Pn -n -p 22 --script ssh-auth-methods --script-args="ssh.user=root" -iL /root/output/list/ssh_open.txt -oA /root/output/nmap/ssh >/dev/null 2>&1 &
fi

{
  echo 'Def_Creds BG Task Check'
  date
} >>/root/output/runtime.txt

#NMAP default-creds
if [ ! -s /root/output/nmap/default-creds.nmap ]; then
  nmap -e eth0 -n -oA /root/output/nmap/default-creds -iL /root/output/list/ipup.txt -p 80,443,8080,8443 --script http-default-accounts --script-args http-default-accounts.fingerprintfile=/opt/nndefaccts/http-default-accounts-fingerprints-nndefaccts.lua >/dev/null 2>&1 &
fi

{
  echo 'END Def_Creds Check'
  date
} >>/root/output/runtime.txt
echo 'END Def_Creds Check'
