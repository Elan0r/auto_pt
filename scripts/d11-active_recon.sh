#!/bin/bash

figlet -w 87 ProSecActiveRecon

if [ -s /root/input/ipint.txt ]; then
  echo '! > IPs OK '
else
  echo "! >> ipint.txt is missing in /root/input/ipint.txt."
  exit 1
fi

echo "Start ActiveRecon" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

#NMAP portquiz.net -> egress filter
if [ -s /root/output/nmap/egress.nmap ]; then
  echo '! > Egress Filter Test already Done!'
else
  echo '! > Egress Filter Background Job start!'
  nmap -e eth0 -oA /root/output/nmap/egress portquiz.net >/dev/null 2>&1 &
fi

#NMAP PE SCAN
if [ -s /root/output/list/ipup.txt ]; then
  echo '! >> nmap PE already Done!'
else
  echo '! > NMAP PE Scan  FAST'

  echo "Start PE Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -PE -sn -n --max-retries 2 -oA /root/output/nmap/pe -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap | sort -u >/root/output/list/ip_pe_up.txt
fi

#NMAP IP Protocol scan
if [ -s /root/output/nmap/ip_protocol.gnmap ]; then
  echo '! >> IP protocol nmap already Done!'
else
  echo '! > NMAP sO IP Protocolscan'

  echo "Start IP Protocol Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -sO --version-intensity 0 --host-timeout 2m --max-retries 2 --min-hostgroup 64 -oA /root/output/ip_protocol -iL /root/input/ipint.txt >/dev/null 2>&1

  #Piping the IP-Addresses of the Targets to a file
  awk '/Up/ {print$2}' /root/output/nmap/ip_protocol.gnmap | sort -u >/root/output/list/ip_proto_up.txt
fi

cat /root/output/list/ip_proto_up.txt /root/output/list/ip_pe_up.txt | sort -u >/root/output/list/ipup.txt

#NMAP Service Scan
if [ -s /root/output/nmap/service.gnmap ]; then
  echo '! >> SERVICE nmap already Done!'
else
  echo '! > NMAP SSVC   SLOW!'

  echo "Start Service Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -sSV -O --osscan-limit --max-os-tries 2 -defeat-rst-ratelimit -n -Pn --max-retries 5 -oA /root/output/nmap/service -iL /root/output/list/ipup.txt >/dev/null 2>&1
fi

#File Splitt in Service LISTs
awk '/135\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/rpc_open.txt
awk '/389\/open/ {print$3}' /root/output/nmap/service.gnmap | sed 's/(/''/' | sed 's/)/''/' | sort -u >/root/output/list/ldap_open.txt
awk '/88\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/kerberos_open.txt
awk '/445\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/smb_open.txt
awk '/443\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssl_open.txt
awk '/22\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssh_open.txt
awk '/6556\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/check_mk_open.txt
awk '/5986\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_https_open.txt
awk '/5985\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_http_open.txt
cat /root/output/list/winrm_http* >/root/output/list/winrm_all_open.txt

#DC LISTs
awk '{if (/ 53\/open/ && / 88\/open/ && / 445\/open/) print$2}' /root/output/nmap/service.gnmap >/root/output/list/dc_ip.txt
for i in $(cat /root/output/list/dc_ip.txt); do
  nslookup "$i" >>/root/output/list/dc_fqdn.txt
done
awk '/name/ {print$4}' /root/output/list/dc_fqdn.txt | cut -d '.' -f 1 | tr '[:lower:]' '[:upper:]' >/root/output/list/dc_nbt.txt

#Info Gathering Summary File
cut -d . -f 1,2,3 /root/output/list/ipup.txt | sort -u | wc -l >/root/output/info_gathering.txt
echo '/24 Networks detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/ipup.txt >>/root/output/info_gathering.txt
echo 'Hosts detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
grep ' open ' /root/output/nmap/service.nmap | wc -l >>/root/output/info_gathering.txt
echo 'Services detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/winrm_all_open.txt >>/root/output/info_gathering.txt
echo 'WinRM Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/check_mk_open.txt >>/root/output/info_gathering.txt
echo 'CheckMK Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/smb_open.txt >>/root/output/info_gathering.txt
echo 'SMB Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/ldap_open.txt >>/root/output/info_gathering.txt
echo 'LDAP Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/kerberos_open.txt >>/root/output/info_gathering.txt
echo 'Kerberos Ports detected' >>/root/output/info_gathering.txt

echo 'END active_recon' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
