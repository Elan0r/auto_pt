#!/bin/bash

mkdir findings

awk '/\+.*:23/ {print$2}' telnet.txt  | cut -d ":" -f 1 | sort -u > findings/telnet.txt
awk '/\+.*OpenSSH/ {print$7,$2}' ssh.txt | sed 's/:22/ /g' | sort -u > findings/openssh_version.txt
awk '/:1433.*Incorrect/ {print$2}' sql.txt | cut -d ":" -f 1 | sort -u > findings/mssql_login.txt
awk '/:5432.*Incorrect/ {print$2}' sql.txt | cut -d ":" -f 1 | sort -u > findings/postgresql_login.txt
awk '/Login Successful.*read-write/ {print$2}' snmp.txt | cut -d ":" -f 1 | sort -u > findings/snmp_default_community_strings_RW.txt
awk '/Login Successful/ {print$2}' snmp.txt  | cut -d ":" -f 1 | sort -u > findings/snmp_default_community_strings.txt
awk '/\+.*SunRPC/ {print$2}' rpc.txt | cut -d ":" -f 1 | sort -u > findings/sunrpc_portmapper.txt
awk '/vulnerable.*MS_T120/ {print$2}' rdp.txt | cut -d ":" -f 1 | sort -u > findings/bluekeep.txt
awk '/Endpoint Mapper (.*services)/ {print$1}' rpc.txt | sort -u > findings/rpc_endpointmapper.txt
awk '/\+.*:143/ {print$2}' mail.txt | cut -d ":" -f 1 | sort -u > findings/imap.txt
awk '/Anonymous READ/ {print$2}' ftp.txt | cut -d ":" -f 1 | sort -u > findings/ftp_anonymous.txt
awk '/FTP Banner/ {print$2}' ftp.txt | cut -d ":" -f 1 | sort -u > findings/ftp_unencrypted.txt
awk '/.*open.*Requires NLA\: No/ {print$1}' rdp.txt | sort -u > findings/rdp.txt
awk '/ServerName.*=/ {print$2}' sql.txt | sed 's/\:/''/g' | sort -u > findings/mssql_browse.txt
