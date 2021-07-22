#!/bin/bash
if [ -d /root/output/loot ]
    echo '! > Folder Exist!'
else
    #Creating Output Folders
    mkdir -p /root/output/loot
    echo '! > Folder Created!'
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
awk '/.*open.*Requires NLA\: No/ {print$1}' /root/output/msf/rdp.txt | sort -u > /root/output/loot/rdp.txt

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
awk '/.*open.*Requires NLA\: No/ {print$1}' /root/output/msf/rdp.txt | sort -u > /root/output/loot/rdp.txt

### NTP
awk '/Vulnerable/ {print$2}' /root/output/msf/ntp.txt | cut -d ":" -f 1  | sort -u > /root/output/loot/ntp_amp.txt

### DNS
awk '/x Amplification/ {print$2}' /root/output/msf/dns.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/dns_amp.txt

### IPMI
awk '/Hash found/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ipmi_hashdump.txt
awk '/VULNERABLE/ {print$2}' /root/output/msf/ipmi.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/ipmi_cipher_zero.txt

### SMTP
awk '/\+.*:143/ {print$2}' /root/output/msf/mail.txt | cut -d ":" -f 1 | sort -u > /root/output/loot/imap.txt

