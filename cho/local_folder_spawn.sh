#!/bin/sh

read -p 'Enter Customer: ' customer
echo ' '
echo 'Spawning Folders'
mkdir -v -p $customer/Onboarding $customer/testing $customer/Report_in_Progress/Attachments 
mkdir -p $customer/testing/smbclient $customer/testing/domain
cd $customer/Report_in_Progress/Attachments
mkdir -p technical/intern technical/extern
cd technical/extern
mkdir -p dns osint information_disclosure mail web/header web/cookies web/ssl_tls
cd ..
cd intern
mkdir -p dns/zone_transfer dns/amplification ad/laps ad/ntlm_auth ad/passpol ad/netsession ftp/anonymous ftp/unencrypted imap ipmi/hashdump ldap/signing mitm/arp mitm/ipv6 mitm/llmnr_nbns network/ip_phones network/broadcast_ping ntp/amplification pop3 printer rdp/no_NLA rdp/bluekeep rpc/fuzzing rpc/null_sessions smb/eternal_blue smb/anonymous_enumeration smb/smb_signing smb/smb_v1 smtp/no_STARTTLS smtp/open_relay snmp/community_string sql/mssql_browse sql/mssql_login sql/postgresql_login sql/mysql_login ssh/version telnet/unencrypted vnc/unencrypted web/iis
cd ../..
mkdir -p social
echo 'Folders created' 
