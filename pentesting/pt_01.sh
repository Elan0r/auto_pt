#!/bin/bash

#####################
# Version 1.1       #
# sekundEntwicklung #
# author:4273       #
#####################

##Vars
IP=`hostname -I | awk '{print$1}'`
IF=`ip -4 a | grep -Pom1 'eth.{1}'`
EXT_IP=`dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short`

##Intro echo ScriptVersion/InternalIP/Intferface/ExternalIP
tput setaf 2;
echo "PT-Script Version 1.0"
tput setaf 7;
echo ""
tput setaf 3;
echo "BoxIP: $IP on Interface: $IF"
echo "ExternalIP: $EXT_IP"
tput setaf 7;
echo ""

##Nmap DNS Host Discovery
tput setaf 2;
echo "Starting DNS Host Discovery"
tput setaf 7;
nmap -e $IF -sL -oA output/nmap/dns10 10.0.0.0/8
tput setaf 2;
echo "10.0.0.0/8 DNS done. 1/5"
tput setaf 7;
nmap -e $IF -sL -oA output/nmap/dns172 172.16.0.0/12
tput setaf 2;
echo "172.16.0.0/16 DNS done. 2/5"
tput setaf 7;
nmap -e $IF -sL -oA output/nmap/dns192 192.168.0.0/16
tput setaf 2;
echo "192.168.0.0/16 DNS done. 3/5"
tput setaf 7;
##Create Lists
cat output/nmap/dns10.nmap output/nmap/dns172.nmap output/nmap/dns192.nmap | grep ')' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -u  > output/list/dns_ips.txt
cat output/nmap/dns10.nmap output/nmap/dns172.nmap output/nmap/dns192.nmap | grep ')' | grep -v seconds | awk '{print$5,$6}' > output/list/hostname_ip.txt

##Check if DNS Query Scan succeded.
if [ -s output/list/dns_ips.txt ]
then
    tput setaf 3;
    echo "DNS IPs: $(wc -l output/list/dns_ips.txt|awk '{print$1}')"
    tput setaf 7;
else
    tput setaf 1;
    echo "DNS Scan failed."
    exit
    tput setaf 7;
fi

##Grep Subnets from dns_ips.txt
cat output/list/dns_ips.txt | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.' | sort -u | awk '{print$0, "0/24"}' | sed 's/ //g' | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > output/list/subnets.txt

##IP Protocol Discovery
tput setaf 2;
echo "Starting IP Protocol Scan"
tput setaf 7;
nmap -e $IF -PO -sn -n -oA output/nmap/alive -iL output/list/subnets.txt
tput setaf 2;
echo "IP Protocol Scan done. 4/5"
tput setaf 7;
grep Up output/nmap/alive.gnmap | cut -d " " -f 2 > output/list/ping_ips.txt

cat output/list/dns_ips.txt output/list/ping_ips.txt | grep -v "10.242.2." | grep -v "$IP" | sort -u > output/list/all_ips.txt
tput setaf 3;
echo "All IPs: $(wc -l output/list/all_ips.txt|awk '{print$1}')"
tput setaf 7;

##Port Scan
tput setaf 2;
echo "Starting Service Port Scan"
tput setaf 7;
nmap -e $IF -sSV -O -p $(cat input/tcp_ports.txt | tr '\n' ',' | sed 's/||$/\n/' | sed 's/.$//') --scan-delay 1s -oA output/nmap/portscan_tcp -iL output/list/all_ips.txt 
tput setaf 2;
echo "Service Port Scan done. 5/5"
tput setaf 7;

##Eyewitness HTTP Screenshot
#tput setaf 2;
#echo "Starting Eyewitness"
#tput setaf 7;
#eyewitness --web -x output/nmap/portscan_tcp.xml --timeout 10 --no-prompt --prepend-https -d output

##Metasploit-Framework
tput setaf 2;
echo "Starting Metasploit-Framework"
tput setaf 7;
msfconsole -qr input/msf_resource.txt


tput setaf 2;
echo "Done!"
tput setaf 7;


########################################################################
##Snippets
#sort -unt . -k 1 ports.txt > tcp_ports.txt
#$(cat tcp_ports.txt | tr '\n' ',' | sed 's/||$/\n/' | sed 's/.$//')
##Ultimate Upscan
#nmap -PE -PS80,443,3389 -PP -PU40125,161 -PA21 --source-port 53 -sn -n
#Error handling
#if [ $? -ne 0 ];then
#   echo "Error!"
#   exit
#fi
