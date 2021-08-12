#!/bin/bash
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
/usr/bin/cp /opt/PCredz/logs/* /root/output/loot/hashes/
fi

if [ -z '$(ls -A /opt/PCredz/CredentialDump-Session.log)' ]; then
   echo '! > No PCredz Session!'
   echo '! >'
else
/usr/bin/cp /opt/PCredz/CredentialDump-Session.log /root/output/loot/hashes/
fi

### Responder
if [ -z '$(ls -A /usr/share/responder/logs/*.txt)' ]; then
   echo '! > No Responder Hashes!'
   echo '! >'
else
/usr/bin/cp /usr/share/responder/logs/*.txt /root/output/loot/hashes/
fi

### CrackMapExec
if [ -z '$(ls -A /root/.cme/logs)' ]; then
   echo '! > No CME Logs!'
   echo '! >'
else
/usr/bin/cp /root/.cme/logs/* /root/output/loot/hashes/
fi

### Metasploit
if [ -z '$(ls -A /root/.msf4/loot)' ]; then
   echo '! > No MSF Loot!'
   echo '! >'
else
   /bin/cp /root/.msf4/loot/* /root/output/loot/
fi

### SNMP
mkdir -p /root/output/loot/intern/snmp
awk '/Login Successful.*read-write/ {print$2}' /root/output/msf/snmp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/snmp/hosts_default_community_rw.txt
awk '/Login Successful/ {print$2}' /root/output/msf/snmp.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/snmp/hosts_default_community_ro.txt

### FTP
mkdir -p /root/output/loot/intern/ftp
awk '/Anonymous READ/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/ftp_anonymous.txt
awk '/FTP Banner/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ftp/ftp_unencrypted.txt

### SSH
mkdir -p /root/output/loot/intern/eol/ssh
awk '/\+.*OpenSSH/ {print$7,$2}' /root/output/msf/ssh.txt | sed 's/:22/ /g' | sort -u > /root/output/loot/intern/eol/ssh/openssh_version.txt

### TELNET
mkdir -p /root/output/loot/intern/telnet
awk '/\+.*:23/ {print$2}' /root/output/msf/telnet.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/telnet/hosts.txt

### SMB
mkdir -p /root/output/loot/intern/smb/eternalblue
awk '/VULNERABLE.*MS17-010/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/smb/eternalblue/hosts.txt
mkdir -p /root/output/loot/intern/smb/user
awk '/Found user:/ {print$2,$6,$7,$8,$9}' /root/output/msf/smb.txt | sort -u > /root/output/loot/intern/smb/user/users.txt
mkdir -p /root/output/loot/intern/eol/windows
awk '/running Windows 200/ {print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/intern/eol/windows/windows_versions.txt
mkdir -p /root/output/loot/intern/smb/v1
awk '/versions:1/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/smb/v1/hosts.txt 
mkdir -p /root/output/loot/intern/smb/sign
awk '/signatures:opt/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 > /root/output/loot/intern/smb/sign/hosts.txt
mkdir -p /root/output/loot/intern/smb/share
awk '/(\(DISK\)|\(IPC\)|\(PRINTER\))/{print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/intern/smb/share/smb_shares.txt

### SQL
mkdir -p /root/output/loot/intern/database/mssql/login
awk '/:1433.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/mssql/login/hosts.txt
mkdir -p /root/output/loot/intern/database/postgresql/login
awk '/:5432.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/postgresql/login/hosts.txt
mkdir -p /root/output/loot/intern/database/mssql/browser
awk '/ServerName.*=/ {print$2}' /root/output/msf/sql.txt | sed 's/\:/''/g' | sort -u > /root/output/loot/intern/database/mssql/browser/hosts.txt
mkdir -p /root/output/loot/intern/database/mysql/login
awk '/LOGIN FAILED.*\(Incorrect: Access/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/database/mysql/login/hosts.txt

### RPC
mkdir -p /root/output/loot/intern/rpc/sun
awk '/\+.*SunRPC/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/sun/hosts.txt
mkdir -p /root/output/loot/intern/rpc/mapper
awk '/Endpoint Mapper (.*services)/ {print$1}' /root/output/msf/rpc.txt | sort -u > /root/output/loot/intern/rpc/mapper/hosts.txt
mkdir -p /root/output/loot/intern/rpc/fuzz
awk '/\*.*(LRPC|TCP|PIPE)/{print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rpc/fuzz/rpc_fuzz.txt
mkdir -p /root/output/loot/intern/rpc/zerologon
mkdir -p /root/output/loot/intern/rpc/printnightmare
mkdir -p /root/output/loot/intern/rpc/petitpotam
mkdir -p /root/output/loot/intern/rpc/null

### RDP
mkdir -p /root/output/loot/intern/rdp/bluekeep
awk '/vulnerable.*MS_T120/ {print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/rdp/bluekeep/hosts.txt
mkdir -p /root/output/loot/intern/rdp/nla
awk '/.*open.*Requires NLA: No/ {print$1}' /root/output/msf/rdp.txt | sort -u > /root/output/loot/intern/rdp/nla/hosts.txt

### NTP
mkdir -p /root/output/loot/intern/ntp/amp
awk '/Vulnerable/ {print$2}' /root/output/msf/ntp.txt | cut -d ":" -f 1  | sort -u > /root/output/loot/intern/ntp/amp/hosts.txt

### DNS
mkdir -p /root/output/loot/intern/dns/amp
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/dns/amp/hosts.txt

### IPMI
mkdir -p /root/output/loot/intern/ipmi/hash
awk '/Hash found/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > mkdir -p /root/output/loot/intern/ipmi/hash/hosts.txt
mkdir -p /root/output/loot/intern/ipmi/cipher
awk '/VULNERABLE/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ipmi/cipher/hosts.txt

### MAIL
mkdir -p /root/output/loot/intern/mail/imap
awk '/\+.*:143/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/imap/hosts.txt
mkdir -p /root/output/loot/intern/mail/pop3
awk '/\+.*:110/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/pop3/hosts.txt
mkdir -p /root/output/loot/intern/mail/relay
awk '/Potential open SMTP relay/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/mail/relay/hosts.txt

### SSDP
mkdir -p /root/output/loot/intern/ssdp/amp
awk '/x Amplification/ {print$2}' /root/output/msf/ssdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/intern/ssdp/amp/hosts.txt
