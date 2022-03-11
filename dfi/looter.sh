#!/bin/bash

figlet ProSecLooter

if [ -d /root/output/loot/hashes -a -d /root/output/loot/intern ]; then
    echo '! > Folder Exist!'
else
    #Creating Output Folders
    mkdir -p /root/output/loot/hashes /root/output/loot/intern
    echo '! > Folder Created!'
fi

echo "Start lootcollector" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

### PCreds
if [ -z '$(ls -A /opt/PCredz/logs)' ]; then
   echo '! >'
   echo '! > No PCredz logs!'
   echo '! >'
else
cp /opt/PCredz/logs/* /root/output/loot/hashes/
fi

if [ -z '$(ls -A /opt/PCredz/CredentialDump-Session.log)' ]; then
   echo '! > No PCredz Session!'
   echo '! >'
else
cp /opt/PCredz/CredentialDump-Session.log /root/output/loot/hashes/
fi

### Responder
if [ -z '$(ls -A /usr/share/responder/logs/*.txt)' ]; then
   echo '! > No Responder Hashes!'
   echo '! >'
else
cp /usr/share/responder/logs/*.txt /root/output/loot/hashes/
fi

### CrackMapExec
if [ -z '$(ls -A /root/.cme/logs)' ]; then
   echo '! > No CME Logs!'
   echo '! >'
else
cp /root/.cme/logs/* /root/output/loot/hashes/
fi

### Metasploit
if [ -z '$(ls -A /root/.msf4/loot)' ]; then
   echo '! > No MSF Loot!'
   echo '! >'
else
   cp /root/.msf4/loot/* /root/output/loot/
fi

### SNMP
mkdir -p /root/output/loot/intern/snmp/community_string
awk '/Login Successful.*read-write/ {print$2}' /root/output/msf/snmp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/snmp/community_string/hosts_default_community_rw.txt
awk '/Login Successful/ {print$2}' /root/output/msf/snmp.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt
mkdir -p /root/output/loot/intern/snmp/v1_v2c
cp /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt /root/output/loot/intern/snmp/v1_v2c/hosts.txt

### FTP
mkdir -p /root/output/loot/intern/ftp/anonymous
awk '/Anonymous READ/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/anonymous/hosts.txt
mkdir -p /root/output/loot/intern/ftp/unencrypted
awk '/FTP Banner/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/unencrypted/hosts.txt

### EOL
mkdir -p /root/output/loot/intern/eol/ssh
awk '/\+.*OpenSSH/ {print$7,$2}' /root/output/msf/ssh.txt | sed 's/:22/ /g' |  sort -u | grep -v '_8.' > /root/output/loot/intern/eol/ssh/openssh_version.txt
mkdir -p /root/output/loot/intern/eol/windows
grep 'running Windows 200\|running Windows 7\|running Windows XP\|running Windows Vista\|running Windows 8\|running Windows 9' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/intern/eol/windows/windows_versions.txt
mkdir -p /root/output/loot/intern/eol/ssh_depricated
awk '/\-1.99/ {print$2}' /root/output/msf/ssh.txt |cut -d : -f 1 | sort -u > /root/output/loot/intern/eol/ssh_depricated/hosts.txt

### TELNET
mkdir -p /root/output/loot/intern/telnet/unencrypted
awk '/\+.*:23/ {print$2}' /root/output/msf/telnet.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/telnet/unencrypted/hosts.txt

### SMB
mkdir -p /root/output/loot/intern/smb/eternal_blue
awk '/VULNERABLE.*MS17-010/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/smb/eternal_blue/hosts.txt
mkdir -p /root/output/loot/intern/smb/smb_v1
awk '/versions:1/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/smb/smb_v1/hosts.txt 
mkdir -p /root/output/loot/intern/smb/smb_signing
awk '/signatures:opt/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/smb/smb_signing/hosts.txt
mkdir -p /root/output/loot/intern/smb/anonymous_enumeration
awk '/(\(DISK\)|\(IPC\)|\(PRINTER\))/{print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt
awk '/Found user:/ {print$2,$6,$7,$8,$9}' /root/output/msf/smb.txt | sort -u > /root/output/loot/intern/smb/anonymous_enumeration/users.txt
mkdir -p /root/output/loot/intern/smb/permission_management
mkdir -p /root/output/loot/intern/smb/sensitive_information

### Database
mkdir -p /root/output/loot/intern/database/mssql/login
awk '/:1433.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/mssql/login/hosts.txt
mkdir -p /root/output/loot/intern/database/postgresql/login
awk '/:5432.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/postgresql/login/hosts.txt
mkdir -p /root/output/loot/intern/database/mssql/browser
awk '/ServerName.*=/ {print$2}' /root/output/msf/sql.txt | sed 's/\:/''/g' | sort -u > /root/output/loot/intern/database/mssql/browser/hosts.txt
mkdir -p /root/output/loot/intern/database/mysql/login
awk '/LOGIN FAILED.*\(Incorrect: Access/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/mysql/login/hosts.txt

### RPC
mkdir -p /root/output/loot/intern/rpc/portmapper
awk '/\+.*SunRPC/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/portmapper/hosts.txt
mkdir -p /root/output/loot/intern/rpc/endpointmap
awk '/Endpoint Mapper (.*services)/ {print$1}' /root/output/msf/rpc.txt | sort -u > /root/output/loot/intern/rpc/endpointmap/hosts.txt
mkdir -p /root/output/loot/intern/rpc/fuzzing
awk '/\*.*(LRPC|TCP|PIPE)/{print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/fuzzing/hosts.txt
mkdir -p /root/output/loot/intern/rpc/amplification
awk '/Vulnerable to Portmap/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/amplification/hosts.txt
mkdir -p /root/output/loot/intern/rpc/zero_logon
awk '/The target is vulnerable/ {print$2}' /root/output/msf/zerologon.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/zero_logon/hosts.txt
mkdir -p /root/output/loot/intern/rpc/print_nightmare
mkdir -p /root/output/loot/intern/rpc/petit_potam
mkdir -p /root/output/loot/intern/rpc/null_sessions

### RDP
mkdir -p /root/output/loot/intern/rdp/bluekeep
awk '/vulnerable.*MS_T120/ {print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rdp/bluekeep/hosts.txt
mkdir -p /root/output/loot/intern/rdp/nla
awk '/.*open.*Requires NLA: No/ {print$1}' /root/output/msf/rdp.txt | sort -u > /root/output/loot/intern/rdp/nla/hosts.txt
mkdir -p /root/output/loot/intern/rdp/ms12-020
awk '/The target is vulnerable.$/{print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rdp/ms12-020/hosts.txt

### NTP
mkdir -p /root/output/loot/intern/ntp/amplification
awk '/Vulnerable/ {print$2}' /root/output/msf/ntp.txt | cut -d ":" -f 1  | sort -u > /root/output/loot/intern/ntp/amplification/hosts.txt

### AD
mkdir -p /root/output/loot/intern/ad/netbios
awk '/NetBIOS/ {print$5}' /root/output/msf/udp_scan.txt | cut -d ":" -f 1  | sort -u > /root/output/loot/intern/ad/netbios/hosts.txt
mkdir -p /root/output/loot/intern/ad/kerberos/asreproast
mkdir -p /root/output/loot/intern/ad/kerberos/delegation
mkdir -p /root/output/loot/intern/ad/kerberos/kerberoasting
mkdir -p /root/output/loot/intern/ad/kerberos/krbtgt
mkdir -p /root/output/loot/intern/ad/kerberos/enumeration
mkdir -p /root/output/loot/intern/ad/kerberos/passwd_spray
mkdir -p /root/output/loot/intern/ad/laps
mkdir -p /root/output/loot/intern/ad/session
mkdir -p /root/output/loot/intern/ad/ntlm_auth
mkdir -p /root/output/loot/intern/ad/passpol
mkdir -p /root/output/loot/intern/ad/quota
mkdir -p /root/output/loot/intern/ad/description
mkdir -p /root/output/loot/intern/ad/gpp_password
mkdir -p /root/output/loot/intern/ad/iam
mkdir -p /root/output/loot/intern/ad/iam/local_admin
mkdir -p /root/output/loot/intern/ad/adcs
mkdir -p /root/output/loot/intern/ad/adcs/esc8
mkdir -p /root/output/loot/intern/ad/adcs/esc2
mkdir -p /root/output/loot/intern/ad/adcs/esc1
mkdir -p /root/output/loot/intern/ad/iam/rights
mkdir -p /root/output/loot/intern/ad/iam/gmsa

### DNS
mkdir -p /root/output/loot/intern/dns/amplification
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/dns/amplification/hosts.txt
mkdir -p /root/output/loot/intern/dns/tunnel
mkdir -p /root/output/loot/intern/dns/zone_transfer
mkdir -p /root/output/loot/intern/dns/filter

### IPMI
mkdir -p /root/output/loot/intern/ipmi/hashdump
awk '/Hash found/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ipmi/hashdump/hosts.txt
mkdir -p /root/output/loot/intern/ipmi/zero_cipher
awk '/VULNERABLE/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ipmi/zero_cipher/hosts.txt

### MAIL
mkdir -p /root/output/loot/intern/mail/imap/unencrypted
awk '/\+.*:143/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/imap/unencrypted/hosts.txt
mkdir -p /root/output/loot/intern/mail/pop3/unencrypted
awk '/\+.*:110/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/pop3/unencrypted/hosts.txt
mkdir -p /root/output/loot/intern/mail/smtp/open_relay
awk '/Potential open SMTP relay/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/smtp/open_relay/hosts.txt
mkdir -p /root/output/loot/intern/mail/smtp/sender_restriction
mkdir -p /root/output/loot/intern/mail/smtp/starttls
mkdir -p /root/output/loot/intern/mail/smtp/unencrypted_auth
mkdir -p /root/output/loot/intern/mail/smtp/rdns

### SSDP
mkdir -p /root/output/loot/intern/ssdp/amplification
awk '/Vulnerable to SSDP/ {print$2}' /root/output/msf/ssdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ssdp/amplification/hosts.txt

### Printer
mkdir -p /root/output/loot/intern/printer/extract
awk '/User=/{print}' /root/output/msf/printer.txt | cut -c18- > /root/output/loot/intern/printer/extract/hosts.txt
mkdir -p /root/output/loot/intern/printer/access
cp /root/output/list/msf_*_printer.txt /root/output/loot/intern/printer/access
awk '/:9100/{print$2}' /root/output/msf/printer.txt | grep -v file: | cut -d : -f 1 | sort -u > /root/output/loot/intern/printer/access/hosts.txt

### MITM
mkdir -p /root/output/loot/intern/mitm/arp
mkdir -p /root/output/loot/intern/mitm/stp
mkdir -p /root/output/loot/intern/mitm/hsrp
mkdir -p /root/output/loot/intern/mitm/vrrp
mkdir -p /root/output/loot/intern/mitm/ipv6
mkdir -p /root/output/loot/intern/mitm/llmnr
mkdir -p /root/output/loot/intern/mitm/nbt
mkdir -p /root/output/loot/intern/mitm/routing
mkdir -p /root/output/loot/intern/mitm/wpad

### Network
mkdir -p /root/output/loot/intern/network/egress_filtering
if [ -s /root/output/nmap/egress.nmap ]; then
cp /root/output/nmap/egress.nmap /root/output/loot/intern/network/egress_filtering/
fi
mkdir -p /root/output/loot/intern/network/icmp
mkdir -p /root/output/loot/intern/network/cdp
mkdir -p /root/output/loot/intern/network/dtp
mkdir -p /root/output/loot/intern/network/hps
mkdir -p /root/output/loot/intern/network/lldp
mkdir -p /root/output/loot/intern/network/stp
mkdir -p /root/output/loot/intern/network/vtp
mkdir -p /root/output/loot/intern/network/trunk
mkdir -p /root/output/loot/intern/network/client_isolation
cp /root/output/nmap/service.nmap /root/output/loot/intern/network/client_isolation
mkdir -p /root/output/loot/intern/network/host-based_firewall
cp /root/output/nmap/service.nmap /root/output/loot/intern/network/host-based_firewall

###VMware
mkdir -p /root/output/loot/intern/vmware/vsan
awk '/The target is vulnerable. System property user.name/ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/vmware/vsan/hosts.txt
mkdir -p /root/output/loot/intern/vmware/vmdir
#missing AWK
mkdir -p /root/output/loot/intern/vmware/ova
awk '/The target is vulnerable. Unauthenticated endpoint access granted./ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/vmware/ova/hosts.txt
mkdir -p /root/output/loot/intern/vmware/vrops
#missing AWK
mkdir -p /root/output/loot/intern/vmware/ceip
awk '/CEIP is fully enabled/ {print$2}' /root/output/msf/vmware.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/vmware/ceip/hosts.txt

### VoIP
mkdir -p /root/output/loot/intern/voip/h323
mkdir -p /root/output/loot/intern/voip/sip
mkdir -p /root/output/loot/intern/voip/rtp

### LDAP
mkdir -p /root/output/loot/intern/ldap/signing
mkdir -p /root/output/loot/intern/ldap/nopac

### Creds
mkdir -p /root/output/loot/intern/creds/lantronix
grep -B 3 'Press Enter for Setup Mode' /root/output/msf/telnet.txt > /root/output/loot/intern/creds/lantronix/raw.txt
awk '/\+/{print$2}' /root/output/loot/intern/creds/lantronix/raw.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/creds/lantronix/hosts.txt
mkdir -p /root/output/loot/intern/creds/bmc
mkdir -p /root/output/loot/intern/creds/network
mkdir -p /root/output/loot/intern/creds/phone
mkdir -p /root/output/loot/intern/creds/printer
mkdir -p /root/output/loot/intern/creds/ups
mkdir -p /root/output/loot/intern/creds/san
grep '|' -B 6 /root/output/nmap/default-creds.nmap > /root/output/loot/intern/creds/creds.txt

mkdir -p /root/output/loot/intern/web/ilo
awk '/The target is vulnerable/{print$2}' /root/output/msf/ilo.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/web/ilo/hosts.txt

### Web
mkdir -p /root/output/loot/intern/web/iis_bypass
grep -B 1 'You can bypass auth' /root/output/msf/web.txt > /root/output/loot/intern/web/iis_bypass/hosts.txt
mkdir -p /root/output/loot/intern/web/ms15-034
awk '/The target is vulnerable/{print$2}' /root/output/msf/web.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/web/ms15-034/hosts.txt
mkdir -p /root/output/loot/intern/web/httpd
mkdir -p /root/output/loot/intern/web/iis
mkdir -p /root/output/loot/intern/web/tomcat
mkdir -p /root/output/loot/intern/web/jboss
mkdir -p /root/output/loot/intern/web/services
mkdir -p /root/output/loot/intern/web/index
mkdir -p /root/output/loot/intern/web/php
mkdir -p /root/output/loot/intern/web/iis_tilde
awk '/The target is vulnerable/{print$2}' /root/output/msf/iis_tilde.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/web/iis_tilde/hosts.txt
mkdir -p /root/output/loot/intern/web/tls
grep -B 6 'TLSv1.1.*enabled' /root/output/msf/sslscan.txt > /root/output/loot/intern/web/tls/prototls.txt
grep -B 4 'SSLv3.*enabled' /root/output/msf/sslscan.txt > /root/output/loot/intern/web/tls/protossl.txt
awk '/Testing/ {print$4}' /root/output/loot/intern/web/tls/proto*.txt | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | sort -u > /root/output/loot/intern/web/tls/hosts.txt

### SSH
mkdir -p /root/output/loot/intern/ssh/root_login
grep -B 11 'password' /root/output/nmap/ssh.nmap > /root/output/loot/intern/ssh/root_login/login.txt
awk '/ for / {print$5}' /root/output/loot/intern/ssh/root_login/login.txt | sort -u > /root/output/loot/intern/ssh/root_login/hosts.txt

### Monitoring
mkdir -p /root/output/loot/intern/monitoring/ids_ips


exit 0
