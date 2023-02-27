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
  awk '/Up/ {print$2}' /root/output/nmap/pe.gnmap | sort -u >/root/output/list/ipup.txt
  echo ''
fi

#NMAP default-creds
if [ -s /root/output/nmap/default-creds.nmap ]; then
  echo '! > Default-Creds test already done!'
else
  echo '! > Default-Creds Background Job start!'
  nmap -e eth0 -n -oA /root/output/nmap/default-creds -iL /root/output/list/ipup.txt -p 80,443,8080,8443 --script http-default-accounts --script-args http-default-accounts.fingerprintfile=/opt/nndefaccts/http-default-accounts-fingerprints-nndefaccts.lua >/dev/null 2>&1 &
fi

#NMAP Service Scan
if [ -s /root/output/nmap/service.gnmap ]; then
  echo '! >> SERVICE nmap already Done!'
else
  echo '! > NMAP SSVC   SLOW!'

  echo "Start Service Scan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  nmap -e eth0 -sSV -defeat-rst-ratelimit -n -Pn --max-retries 5 -oA /root/output/nmap/service -iL /root/output/list/ipup.txt >/dev/null 2>&1
  echo ''
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

#sslscan 4 weak cipher
if [ -s /root/output/msf/sslscan.txt ]; then
  echo '! >> SSL Scan already Done.'
else
  echo '! > Weak Ciphers Background Job start!'
  sslscan --targets=/root/output/list/ssl_open.txt >/root/output/msf/sslscan.txt 2>&1 &
fi

#Root login check
if [ -s /root/output/nmap/ssh.nmap ]; then
  echo '! >> SSH ROOT login Scan already Done'
else
  echo '! > Checking SSH Root login'
  nmap -Pn -n -p 22 --script ssh-auth-methods --script-args="ssh.user=root" -iL /root/output/list/ssh_open.txt -oA /root/output/nmap/ssh >/dev/null 2>&1 &
fi

if [ -s /root/output/list/smb_sign_off.txt ]; then
  echo '! >> RELAY LIST EXISTS'
else
  echo '! > BUILDING CME SMB RELAY LIST'

  echo "Start CME build Relay List" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt

  #Using Crackmap to Check which of the IP's with 445 open have Signing:false
  crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >/root/output/cme_beauty.txt 2>&1
fi

#Create Relay LISTs
for i in $(cat /root/output/list/rpc_open.txt); do
  echo rpc://"$i" >>/root/output/list/relay_rpc.txt
done

for i in $(cat /root/output/list/ldap_open.txt); do
  echo ldaps://"$i" >>/root/output/list/relay_ldap.txt
done

for i in $(cat /root/output/list/kerberos_open.txt); do
  echo dcsync://"$i" >>/root/output/list/relay_dcsync.txt
done

for i in $(cat /root/output/list/smb_sign_off.txt); do
  echo smb://"$i" >>/root/output/list/relay_smb.txt
done

cat /root/output/list/relay* >/root/output/list/relay_all.txt
echo 'Done'

exit 0
