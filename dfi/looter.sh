#!/bin/bash

figlet ProSecLooter

if [ -d /root/output/loot/hashes -a -d /root/output/loot/intern ]; then
    echo '! > Folder Exist!'
else
    #Creating Output Folders
    mkdir -p /root/output/loot/hashes /root/output/loot/intern
    echo '! > Folder Created!'
fi

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
mkdir -p /root/output/loot/intern/snmp/unencrypted

### FTP
mkdir -p /root/output/loot/intern/ftp/anonymous
awk '/Anonymous READ/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/anonymous/hosts.txt
mkdir -p /root/output/loot/intern/ftp/unencrypted
awk '/FTP Banner/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/unencrypted/hosts.txt

### EOL
mkdir -p /root/output/loot/intern/eol/ssh
awk '/\+.*OpenSSH/ {print$7,$2}' /root/output/msf/ssh.txt | sed 's/:22/ /g' | sort -u > /root/output/loot/intern/eol/ssh/openssh_version.txt
mkdir -p /root/output/loot/intern/eol/windows
grep 'running Windows 200\|running Windows 7\|running Windows XP\|running Windows Vista\|running Windows 8 ' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/intern/eol/windows/windows_versions.txt
mkdir -p /root/output/loot/intern/eol/ssh_depricated
awk '/\-1.99/ {print$2}' /root/output/msf/ssh.txt |cut -d : -f 1 | sort -u > /root/output/loot/intern/eol/ssh_depricated/hosts.txt

### TELNET
mkdir -p /root/output/loot/intern/telnet
awk '/\+.*:23/ {print$2}' /root/output/msf/telnet.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/telnet/hosts.txt

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
mkdir -p /root/output/loot/intern/rpc/portmaper
awk '/\+.*SunRPC/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/portmaper/hosts.txt
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
mkdir -p /root/output/loot/intern/ad/laps
mkdir -p /root/output/loot/intern/ad/netsession
mkdir -p /root/output/loot/intern/ad/ntlm_auth
mkdir -p /root/output/loot/intern/ad/passpol
mkdir -p /root/output/loot/intern/ad/quota

### DNS
mkdir -p /root/output/loot/intern/dns/amplification
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/dns/amplification/hosts.txt
mkdir -p /root/output/loot/intern/dns/tunnel
mkdir -p /root/output/loot/intern/dns/zone_transfer

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

### SSDP
mkdir -p /root/output/loot/intern/ssdp/amplification
awk '/Vulnerable to SSDP/ {print$2}' /root/output/msf/ssdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ssdp/amplification/hosts.txt

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
mkdir -p /root/output/loot/intern/network/broadcast_ping
mkdir -p /root/output/loot/intern/network/cdp
mkdir -p /root/output/loot/intern/network/dtp
mkdir -p /root/output/loot/intern/network/hps
mkdir -p /root/output/loot/intern/network/lldp
mkdir -p /root/output/loot/intern/network/stp
mkdir -p /root/output/loot/intern/network/vtp

### VoIP
mkdir -p /root/output/loot/intern/voip/h323
mkdir -p /root/output/loot/intern/voip/sip
mkdir -p /root/output/loot/intern/voip/rtp

### LDAP
mkdir -p /root/output/loot/intern/ldap/signing

### Creds
mkdir -p /root/output/loot/intern/creds/bmc
mkdir -p /root/output/loot/intern/creds/network
mkdir -p /root/output/loot/intern/creds/phone
mkdir -p /root/output/loot/intern/creds/printer
mkdir -p /root/output/loot/intern/creds/ups
mkdir -p /root/output/loot/intern/creds/san

### Web
mkdir -p /root/output/loot/intern/web/httpd
mkdir -p /root/output/loot/intern/web/iis
mkdir -p /root/output/loot/intern/web/tomcat
mkdir -p /root/output/loot/intern/web/jboss
mkdir -p /root/output/loot/intern/web/services
mkdir -p /root/output/loot/intern/web/index

exit 0
