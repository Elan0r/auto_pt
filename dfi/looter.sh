#!/bin/bash
if [ -d /root/output/loot -a -d /root/output/loot/hashes ]; then
    echo '! > Folder Exist!'
else
    #Creating Output Folders
    mkdir -p /root/output/loot /root/output/loot/hashes
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
awk '/Login Successful.*read-write/ {print$2}' /root/output/msf/snmp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/snmp_default_community_strings_RW.txt
awk '/Login Successful/ {print$2}' /root/output/msf/snmp.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/snmp_default_community_strings.txt

### FTP
awk '/Anonymous READ/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ftp_anonymous.txt
awk '/FTP Banner/ {print$2}' /root/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ftp_unencrypted.txt

### SSH
awk '/\+.*OpenSSH/ {print$7,$2}' /root/output/msf/ssh.txt | sed 's/:22/ /g' | sort -u > /root/output/loot/openssh_version.txt

### TELNET
awk '/\+.*:23/ {print$2}' /root/output/msf/telnet.txt  | cut -d ":" -f 1 | sort -u > /root/output/loot/telnet.txt

### SMB
awk '/VULNERABLE.*MS17-010/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/eternalblue.txt
awk '/Found user:/ {print$2,$6,$7,$8,$9}' /root/output/msf/smb.txt | sort -u > /root/output/loot/users.txt
awk '/running Windows 200/ {print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/eol_windows.txt
awk '/versions:1/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/smb_v1.txt 
awk '/signatures:opt/ {print$2}' /root/output/msf/smb.txt | cut -d ":" -f 1 > /root/output/loot/smb_no_signing.txt
awk '/(\(DISK\)|\(IPC\)|\(PRINTER\))/{print}' /root/output/msf/smb.txt | cut -c18- | sed 's/:... //' | sort -u > /root/output/loot/smb_shares.txt

### SQL
awk '/:1433.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/mssql_login.txt
awk '/:5432.*Incorrect/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/postgresql_login.txt
awk '/ServerName.*=/ {print$2}' /root/output/msf/sql.txt | sed 's/\:/''/g' | sort -u > /root/output/loot/mssql_browse.txt
awk '/LOGIN FAILED.*\(Incorrect: Access/ {print$2}' /root/output/msf/sql.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/mysql_login.txt

### RPC
awk '/\+.*SunRPC/ {print$2}' /root/output/msf/rpc.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/sunrpc_portmapper.txt
awk '/Endpoint Mapper (.*services)/ {print$1}' /root/output/msf/rpc.txt | sort -u > /root/output/loot/rpc_endpointmapper.txt

### RDP
awk '/vulnerable.*MS_T120/ {print$2}' /root/output/msf/rdp.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/bluekeep.txt
awk '/.*open.*Requires NLA: No/ {print$1}' /root/output/msf/rdp.txt | sort -u > /root/output/loot/rdp.txt

### NTP
awk '/Vulnerable/ {print$2}' /root/output/msf/ntp.txt | cut -d ":" -f 1  | sort -u > /root/output/loot/ntp_amp.txt

### DNS
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/dns_amp.txt

### IPMI
awk '/Hash found/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ipmi_hashdump.txt
awk '/VULNERABLE/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ipmi_cipher_zero.txt

### SMTP
awk '/\+.*:143/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/imap.txt
