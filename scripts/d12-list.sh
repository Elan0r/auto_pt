#!/bin/bash

figlet ProSecLists

echo 'START List Creation' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'START List Creation'

#File Splitt in Service LISTs
awk '/135\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/rpc_open.txt
awk '/389\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ldap_open.txt
awk '/636\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ldaps_open.txt
awk '/88\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/kerberos_open.txt
awk '/445\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/smb_open.txt
awk '/443\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssl_open.txt
awk '/22\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssh_open.txt
awk '/6556\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/check_mk_open.txt
awk '/3389\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/rdp_open.txt
awk '/5986\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_https_open.txt
awk '/5985\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_http_open.txt
cat /root/output/list/winrm_http* >/root/output/list/winrm_all_open.txt

#Create Relay LISTs
for i in $(cat /root/output/list/rpc_open.txt); do
  echo rpc://"$i" >>/root/output/list/relay_rpc.txt
done

for i in $(cat /root/output/list/ldap_open.txt); do
  echo ldap://"$i" >>/root/output/list/relay_ldap.txt
done

for i in $(cat /root/output/list/ldaps_open.txt); do
  echo ldaps://"$i" >>/root/output/list/relay_ldaps.txt
done

for i in $(cat /root/output/list/kerberos_open.txt); do
  echo dcsync://"$i" >>/root/output/list/relay_dcsync.txt
done

cat /root/output/list/relay* >/root/output/list/relay_all.txt

#DC LISTs
awk '{if (/ 53\/open/ && / 88\/open/ && / 445\/open/) print$2}' /root/output/nmap/service.gnmap >/root/output/list/dc_ip.txt
for i in $(cat /root/output/list/dc_ip.txt); do
  nslookup "$i" "$i" | awk '/name/ {print$4}' >>/root/output/list/dc_fqdn.txt
done
cut -d '.' -f 1 /root/output/list/dc_fqdn.txt | tr '[:lower:]' '[:upper:]' >/root/output/list/dc_nbt.txt
cut -d '.' -f 2,3,4,5 /root/output/list/dc_fqdn.txt | sort -u | sed 's/\.$//' >/root/output/list/domainname.txt

echo 'END List Creation' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END List Creation'
