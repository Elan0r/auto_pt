#!/bin/bash
if [ -d findings ]
    echo '! > Folder Exist!'
else
    #Creating Output Folders
    mkdir -p findings
    echo '! > Folder Created!'
fi

### SNMP
awk '/Login Successful.*read-write/ {print$2}' snmp.txt | cut -d ":" -f 1 | sort -u > findings/snmp_default_community_strings_RW.txt
awk '/Login Successful/ {print$2}' snmp.txt  | cut -d ":" -f 1 | sort -u > findings/snmp_default_community_strings.txt

### FTP
awk '/Anonymous READ/ {print$2}' ftp.txt | cut -d ":" -f 1 | sort -u > findings/ftp_anonymous.txt
awk '/FTP Banner/ {print$2}' ftp.txt | cut -d ":" -f 1 | sort -u > findings/ftp_unencrypted.txt

### SSH
awk '/\+.*OpenSSH/ {print$7,$2}' ssh.txt | sed 's/:22/ /g' | sort -u > findings/openssh_version.txt

### TELNET
awk '/\+.*:23/ {print$2}' telnet.txt  | cut -d ":" -f 1 | sort -u > findings/telnet.txt

### SMB
awk '/VULNERABLE.*MS17-010/ {print$2}' smb.txt | cut -d ":" -f 1 | sort -u > findings/eternalblue.txt
awk '/Found user:/ {print$2,$6,$7,$8,$9}' smb.txt | sort -u > findings/users.txt
awk '/running Windows 200/ {print}' smb.txt | cut -c18- | sed 's/:... //' | sort -u > findings/eol_windows.txt

### SQL
awk '/:1433.*Incorrect/ {print$2}' sql.txt | cut -d ":" -f 1 | sort -u > findings/mssql_login.txt
awk '/:5432.*Incorrect/ {print$2}' sql.txt | cut -d ":" -f 1 | sort -u > findings/postgresql_login.txt
awk '/ServerName.*=/ {print$2}' sql.txt | sed 's/\:/''/g' | sort -u > findings/mssql_browse.txt
awk '/LOGIN FAILED.*\(Incorrect: Access/ {print$2}' sql.txt | cut -d ":" -f 1 | sort -u > findings/mysql_login.txt

### RPC
awk '/\+.*SunRPC/ {print$2}' rpc.txt | cut -d ":" -f 1 | sort -u > findings/sunrpc_portmapper.txt
awk '/Endpoint Mapper (.*services)/ {print$1}' rpc.txt | sort -u > findings/rpc_endpointmapper.txt

### RDP
awk '/vulnerable.*MS_T120/ {print$2}' rdp.txt | cut -d ":" -f 1 | sort -u > findings/bluekeep.txt
awk '/.*open.*Requires NLA: No/ {print$1}' rdp.txt | sort -u > findings/rdp.txt

### NTP
awk '/Vulnerable/ {print$2}' ntp.txt | cut -d ":" -f 1  | sort -u > findings/ntp_amp.txt

### DNS
awk '/x Amplification/ {print$2}' dns.txt | cut -d ":" -f 1 | sort -u > findings/dns_amp.txt

### IPMI
awk '/Hash found/ {print$2}' ipmi.txt | cut -d ":" -f 1 | sort -u > findings/ipmi_hashdump.txt

### SMTP
awk '/\+.*:143/ {print$2}' mail.txt | cut -d ":" -f 1 | sort -u > findings/imap.txt

