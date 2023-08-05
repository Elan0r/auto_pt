#!/bin/bash

figlet -w 94 Counter

echo "Start Finding Counter" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

echo "SMB_Signing" >/root/output/findings.txt
wc -l /root/output/loot/intern/smb/smb_signing/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/smb/smb_signing/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SMB_v1" >>/root/output/findings.txt
wc -l /root/output/loot/intern/smb/smb_v1/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/smb/smb_v1/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SMB_shares" >>/root/output/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SMB_Users" >>/root/output/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/users.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/smb/anonymous_enumeration/users.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "RDP_NLA" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rdp/nla/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rdp/nla/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "NetBIOS" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ad/netbios/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ad/netbios/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Telnet" >>/root/output/findings.txt
wc -l /root/output/loot/intern/telnet/unencrypted/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/telnet/unencrypted/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SSH_Depricated" >>/root/output/findings.txt
wc -l /root/output/loot/intern/eol/ssh_depricated/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/eol/ssh_depricated/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SSH_eol" >>/root/output/findings.txt
wc -l /root/output/loot/intern/eol/ssh/openssh_version.txt >>/root/output/findings.txt
cut -d " " -f 2 /root/output/loot/intern/eol/ssh/openssh_version.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SSH_login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ssh/root_login/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ssh/root_login/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "IPMI_Cipher0" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ipmi/zero_cipher/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ipmi/zero_cipher/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "IPMI_Hashdump" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ipmi/hashdump/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ipmi/hashdump/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SNMP_V1V2" >>/root/output/findings.txt
wc -l /root/output/loot/intern/snmp/v1_v2c/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/snmp/v1_v2c/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "SNMP_RO" >>/root/output/findings.txt
wc -l /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "FTP_Anonymous" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ftp/anonymous/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ftp/anonymous/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "FTP_Unencrypted" >>/root/output/findings.txt
wc -l /root/output/loot/intern/ftp/unencrypted/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/ftp/unencrypted/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

###Database
echo "MSSQL_Browser" >>/root/output/findings.txt
wc -l /root/output/loot/intern/database/mssql/browser/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/database/mssql/browser/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "MSSQL_login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/database/mssql/login/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/database/mssql/login/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "MySQL_Login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/database/mysql/login/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/database/mysql/login/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "PostgreSql_login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/database/postgresql/login/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/database/postgresql/login/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "MongoDB_Login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/database/mongodb/login/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/database/mongodb/login/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Printer_access" >>/root/output/findings.txt
wc -l /root/output/loot/intern/printer/access/msf_*_printer.txt >>/root/output/findings.txt
tail -n +2 /root/output/loot/intern/printer/access/msf_*_printer.txt | cut -c2- | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Minolta_Password_Extract" >>/root/output/findings.txt
wc -l /root/output/loot/intern/printer/extract/hosts.txt >>/root/output/findings.txt
cut -d ":" -f 4 /root/output/loot/intern/printer/extract/hosts.txt | sed 's/.*=//g' | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "IIS_Tilde/Shortname" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/iis_tilde/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/iis_tilde/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "IMAP" >>/root/output/findings.txt
wc -l /root/output/loot/intern/mail/imap/unencrypted/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/mail/imap/unencrypted/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "POP3" >>/root/output/findings.txt
wc -l /root/output/loot/intern/mail/pop3/unencrypted/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/mail/pop3/unencrypted/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

###RPC
echo "RPC_Portmap" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rpc/portmapper/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rpc/portmapper/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "RPC_Portmap_Amp" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rpc/amplification/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rpc/amplification/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "NFS_share" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rpc/nfs/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rpc/nfs/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Lantronix_login" >>/root/output/findings.txt
wc -l /root/output/loot/intern/creds/lantronix/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/creds/lantronix/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "ZeroLogon" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rpc/zero_logon/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rpc/zero_logon/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "BlueKeep" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rdp/bluekeep/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rdp/bluekeep/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "MS12-020" >>/root/output/findings.txt
wc -l /root/output/loot/intern/rdp/ms12-020/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/rdp/ms12-020/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "EternalBlue" >>/root/output/findings.txt
wc -l /root/output/loot/intern/smb/eternal_blue/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/smb/eternal_blue/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Heartbleed" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/tls/heartbleed/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/tls/heartbleed/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "HP_iLO_Auth_Bypass" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/ilo/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/ilo/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "VMWARE_VSAN" >>/root/output/findings.txt
wc -l /root/output/loot/intern/vmware/vsan/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/vmware/vsan/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "VMWARE_VMDIR" >>/root/output/findings.txt
wc -l /root/output/loot/intern/vmware/vmdir/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/vmware/vmdir/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "VMWARE_OVA" >>/root/output/findings.txt
wc -l /root/output/loot/intern/vmware/ova/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/vmware/ova/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "VMWARE_CEIP" >>/root/output/findings.txt
wc -l /root/output/loot/intern/vmware/ceip/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/vmware/ceip/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "VMWARE_Log4Shell" >>/root/output/findings.txt
wc -l /root/output/loot/intern/vmware/log4shell/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/vmware/log4shell/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "MS15-034_HTTP_dump" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/ms15-034/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/ms15-034/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "IIS_Auth_Bypass" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/iis_bypass/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/iis_bypass/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Log4Shell" >>/root/output/findings.txt
wc -l /root/output/loot/intern/web/log4shell/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/log4shell/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "DNS_Amp" >>/root/output/findings.txt
wc -l /root/output/loot/intern/dns/amplification/hosts.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/dns/amplification/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Windows_eol" >>/root/output/findings.txt
wc -l /root/output/loot/intern/eol/windows/windows_versions.txt >>/root/output/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/eol/windows/windows_versions.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo "Devices" >>/root/output/findings.txt
tail -n +2 /root/output/list/msf_hosts.txt | wc -l >>/root/output/findings.txt
echo "" >>/root/output/findings.txt
echo "Services" >>/root/output/findings.txt
tail -n +2 /root/output/list/msf_services.csv | wc -l >>/root/output/findings.txt
echo "" >>/root/output/findings.txt

echo 'END Counting' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END Counting'
