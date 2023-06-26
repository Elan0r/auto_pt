#!/bin/bash

figlet ListCreation

echo 'START List Creation' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'START List Creation'

#File Splitt in Service LISTs
awk '/22\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssh_open.txt
awk '/88\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/kerberos_open.txt
awk '/111\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/rpc_open.txt
awk '/135\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/msrpc_open.txt
awk '/389\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ldap_open.txt
awk '/443\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ssl_open.txt
awk '/445\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/smb_open.txt
awk '/636\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/ldaps_open.txt
awk '/1433\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/mssql_open.txt
awk '/3306\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/mysql_open.txt
awk '/3389\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/rdp_open.txt
awk '/5900\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/vnc_open.txt
awk '/5986\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_https_open.txt
awk '/5985\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/winrm_http_open.txt
awk '/6556\/open/ {print$2}' /root/output/nmap/service.gnmap | sort -u >/root/output/list/check_mk_open.txt
cat /root/output/list/winrm_http* >/root/output/list/winrm_all_open.txt

#Create Relay LISTs
sed 's%^%rpc://%' /root/output/list/msrpc_open.txt >/root/output/list/relay_rpc.txt
sed 's%^%ldap://%' /root/output/list/ldap_open.txt >/root/output/list/relay_ldap.txt
sed 's%^%ldaps://%' /root/output/list/ldaps_open.txt >/root/output/list/relay_ldaps.txt
sed 's%^%dcsync://%' /root/output/list/kerberos_open.txt >/root/output/list/relay_dcsync.txt

#DC LISTs
awk '{if (/ 53\/open/ && / 88\/open/ && / 445\/open/) print$2}' /root/output/nmap/service.gnmap >/root/output/list/dc_ip.txt
for i in $(cat /root/output/list/dc_ip.txt); do
  nslookup "$i" "$i" | awk '/name/ {print$4}' >>/root/output/list/dc_fqdn.txt
done
cut -d '.' -f 1 /root/output/list/dc_fqdn.txt | tr '[:lower:]' '[:upper:]' >/root/output/list/dc_nbt.txt
cut -d '.' -f 2,3,4,5 /root/output/list/dc_fqdn.txt | sort -u | sed 's/\.$//' >/root/output/list/domainname.txt

#scrying
/opt/scrying/scrying --nmap /root/output/nmap/service.xml --test-import >/root/output/list/scrying_raw.txt
grep http /root/output/list/scrying_raw.txt | tr -d '[:blank:]' >/root/output/list/scrying_web.txt
sed 's%^%vnc://%' /root/output/list/vnc_open.txt >/root/output/list/scrying_vnc.txt
sed 's%^%rdp://%' /root/output/list/rdp_open.txt >/root/output/list/scrying_rdp.txt

echo 'END List Creation' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END List Creation'
