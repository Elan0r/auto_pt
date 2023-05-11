#!/bin/bash

figlet ProSecLooter

echo "Start lootcollector" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

### PCreds
if [ -z "$(ls -A /opt/PCredz/logs)" ]; then
  echo '! >'
  echo '! > No PCredz logs!'
  echo '! >'
else
  cp /opt/PCredz/logs/* /root/output/loot/hashes/
fi

if [ -z "$(ls -A /opt/PCredz/CredentialDump-Session.log)" ]; then
  echo '! > No PCredz Session!'
  echo '! >'
else
  cp /opt/PCredz/CredentialDump-Session.log /root/output/loot/hashes/
fi

### Responder
if [ -z "$(ls -A /usr/share/responder/logs/*.txt)" ]; then
  echo '! > No Responder Hashes!'
  echo '! >'
else
  cp /usr/share/responder/logs/*.txt /root/output/loot/hashes/
fi

### CrackMapExec
if [ -z "$(ls -A /root/.cme/logs)" ]; then
  echo '! > No CME Logs!'
  echo '! >'
else
  cp /root/.cme/logs/* /root/output/loot/hashes/
fi

### Metasploit
if [ -z "$(ls -A /root/.msf4/loot)" ]; then
  echo '! > No MSF Loot!'
  echo '! >'
else
  cp /root/.msf4/loot/* /root/output/loot/
fi

### SNMP
awk '/Login Successful.*read-write/ {print$2}' /root/output/msf/snmp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/snmp/community_string/hosts_default_community_rw.txt
awk '/Login Successful/ {print$2}' /root/output/msf/snmp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt
cp /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt /root/output/loot/intern/snmp/v1_v2c/hosts.txt

### FTP
awk '/Anonymous READ/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ftp/anonymous/hosts.txt
awk '/FTP Banner/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ftp/unencrypted/hosts.txt

### EOL
awk '/\+.*OpenSSH/ {print$7,$2}' /root/output/msf/ssh.txt | sed 's/:22/ /g' | sort -u | grep -v '_8.' >/root/output/loot/intern/eol/ssh/openssh_version.txt
grep -a 'running Windows 200\|running Windows 7\|running Windows XP\|running Windows Vista\|running Windows 8\|running Windows 9' /root/output/msf/smb.txt | cut -c5- | sed 's/:... //' | sort -u >/root/output/loot/intern/eol/windows/windows_versions.txt
awk '/\-1.99/ {print$2}' /root/output/msf/ssh.txt | cut -d : -f 1 | sort -u >/root/output/loot/intern/eol/ssh_depricated/hosts.txt

### TELNET
awk '/\+.*:23/ {print$2}' /root/output/msf/telnet.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/telnet/unencrypted/hosts.txt

### SMB
awk '/VULNERABLE.*MS17-010/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/smb/eternal_blue/hosts.txt
awk '/versions:1/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/smb/smb_v1/hosts.txt
awk '/signatures:opt/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/smb/smb_signing/hosts.txt
awk '/(\(DISK\)|\(IPC\)|\(PRINTER\))/{print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u >/root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt
awk '/Found user:/ {print$2,$6,$7,$8,$9}' /root/output/msf/smb.txt | sort -u >/root/output/loot/intern/smb/anonymous_enumeration/users.txt

### Database
awk '/:1433.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/database/mssql/login/hosts.txt
awk '/:5432.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/database/postgresql/login/hosts.txt
awk '/ServerName.*=/ {print$2}' /root/output/msf/sql.txt | sed 's/\:/''/g' | sort -u >/root/output/loot/intern/database/mssql/browser/hosts.txt
awk '/LOGIN FAILED.*\(Incorrect: Access/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/database/mysql/login/hosts.txt
awk '/doesn'\''t use authentication/ {print$2}' /root/output/msf/nosql.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/database/mongodb/login/hosts.txt
awk '/5432 - Login Successful/ {print}' /root/output/msf/sql.txt >/root/output/loot/intern/creds/postgresql.txt
awk '/1433 - Login Successful/ {print}' /root/output/msf/sql.txt >/root/output/loot/intern/creds/mssql.txt
awk '/Success:/ {print}' /root/output/msf/sql.txt >/root/output/loot/intern/creds/mysql.txt

### RPC
awk '/\+.*SunRPC/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rpc/portmapper/hosts.txt
awk '/Endpoint Mapper (.*services)/ {print$1}' /root/output/msf/rpc.txt | sort -u >/root/output/loot/intern/rpc/endpointmap/hosts.txt
awk '/Vulnerable to Portmap/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rpc/amplification/hosts.txt
awk '/The target is vulnerable/ {print$2}' /root/output/msf/zerologon.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rpc/zero_logon/hosts.txt
awk '/NFS Export/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rpc/nfs/hosts.txt
awk '/NFS Export/ {print}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rpc/nfs/raw.txt

### RDP
awk '/vulnerable.*MS_T120/ {print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rdp/bluekeep/hosts.txt
awk '/.*open.*Requires NLA: No/ {print$1}' /root/output/msf/rdp.txt | sort -u >/root/output/loot/intern/rdp/nla/hosts.txt
awk '/The target is vulnerable.$/{print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/rdp/ms12-020/hosts.txt

### NTP
awk '/Vulnerable/ {print$2}' /root/output/msf/ntp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ntp/amplification/hosts.txt

### AD
awk '/NetBIOS/ {print$5}' /root/output/msf/udp_scan.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ad/netbios/hosts.txt

### DNS
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/dns/amplification/hosts.txt

### IPMI
awk '/Hash found/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ipmi/hashdump/hosts.txt
awk '/- VULNERABLE/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ipmi/zero_cipher/hosts.txt

### MAIL
awk '/\+.*:143/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/mail/imap/unencrypted/hosts.txt
awk '/\+.*:110/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/mail/pop3/unencrypted/hosts.txt
awk '/Potential open SMTP relay/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/mail/smtp/open_relay/hosts.txt

### SSDP
awk '/Vulnerable to SSDP/ {print$2}' /root/output/msf/ssdp.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/ssdp/amplification/hosts.txt

### Printer
awk '/User=/{print}' /root/output/msf/printer.txt | cut -c18- >/root/output/loot/intern/printer/extract/hosts.txt
cp /root/output/list/msf_*_printer.txt /root/output/loot/intern/printer/access
awk '/:9100/{print$2}' /root/output/msf/printer.txt | grep -v file: | cut -d : -f 1 | sort -u >/root/output/loot/intern/printer/access/hosts.txt

### Network
cp /root/output/nmap/egress.nmap /root/output/loot/intern/network/egress_filtering/
cp /root/output/nmap/service.nmap /root/output/loot/intern/network/client_isolation
cp /root/output/list/msf_services.csv /root/output/loot/intern/network/segmentation_segregation
cp /root/output/nmap/service.nmap /root/output/loot/intern/network/host-based_firewall

###VMware
awk '/The target is vulnerable. System property user.name/ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/vmware/vsan/hosts.txt
awk '/is vulnerable to CVE-2020-3952/ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/vmware/vmdir/hosts.txt
awk '/The target is vulnerable. Unauthenticated endpoint access granted./ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/vmware/ova/hosts.txt
#missing AWK vrops
awk '/CEIP is fully enabled/ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/vmware/ceip/hosts.txt
awk '/Log4Shell found.*vsphere/{print$2}' /root/output/msf/log4j.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/vmware/log4shell/hosts.txt

### Creds
grep -a -B 3 'Press Enter for Setup Mode' /root/output/msf/telnet.txt >/root/output/loot/intern/creds/lantronix/raw.txt
awk '/\+/{print$2}' /root/output/loot/intern/creds/lantronix/raw.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/creds/lantronix/hosts.txt
grep -a '|' -B 6 /root/output/nmap/default-creds.nmap >/root/output/loot/intern/creds/creds.txt

awk '/The target is vulnerable/{print$2}' /root/output/msf/ilo.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/web/ilo/hosts.txt

### Web
grep -a -B 1 'You can bypass auth' /root/output/msf/web.txt | awk '/against/ {print$5}' | sort -u >/root/output/loot/intern/web/iis_bypass/hosts.txt
awk '/The target is vulnerable/{print$2}' /root/output/msf/web.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/web/ms15-034/hosts.txt
awk '/The target is vulnerable/{print$2}' /root/output/msf/iis_tilde.txt | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/web/iis_tilde/hosts.txt

grep -a -B 6 'TLSv1.1.*enabled' /root/output/msf/sslscan.txt >/root/output/loot/intern/web/tls/prototls.txt
grep -a -B 4 'SSLv3.*enabled' /root/output/msf/sslscan.txt >/root/output/loot/intern/web/tls/protossl.txt
cp /root/output/msf/sslscan.txt /root/output/loot/intern/web/tls/
awk '/Testing/ {print$4}' /root/output/loot/intern/web/tls/proto*.txt | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | sort -u >/root/output/loot/intern/web/tls/hosts.txt
grep -a -v 'not vulnerable' /root/output/msf/sslscan.txt | grep -B 22 vulnerable | grep Connected | cut -d ' ' -f 3 >/root/output/loot/intern/web/tls/heartbleed/hosts.txt
grep -a -v 'not vulnerable' /root/output/msf/sslscan.txt | grep -B 22 vulnerable >/root/output/loot/intern/web/tls/heartbleed/raw.txt
awk '/Log4Shell found/{print}' /root/output/msf/log4j.txt | grep -v 'vsphere' | awk '//{print$2}' | cut -d ":" -f 1 | sort -u >/root/output/loot/intern/web/log4shell/hosts.txt

### SSH
grep -a -B 11 'password' /root/output/nmap/ssh.nmap >/root/output/loot/intern/ssh/root_login/login.txt
awk '/ for / {print$5}' /root/output/loot/intern/ssh/root_login/login.txt | sort -u >/root/output/loot/intern/ssh/root_login/hosts.txt

echo 'END Looting' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END Looting'
