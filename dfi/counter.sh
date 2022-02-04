#!/bin/bash
figlet -w 94 ProSecCounter

echo "PS-TN-2020-0005 smb_signing" > /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/smb_signing/hosts.txt >> /root/output/loot/intern//findings.txt
cat  /root/output/loot/intern/smb/smb_signing/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0008 SMB_v1" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/smb_v1/hosts.txt >> /root/output/loot/intern//findings.txt
cat  /root/output/loot/intern/smb/smb_v1/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0020 RDP_NLA" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/nla/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rdp/nla/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0009 NetBIOS_Information Disclosure" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ad/netbios/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ad/netbios/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0002 Telnet" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/telnet/unencrypted/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/telnet/unencrypted/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0012 IPMI_Cipher" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ipmi/zero_cipher/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ipmi/zero_cipher/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0013 IPMI_Hash" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ipmi/hashdump/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ipmi/hashdump/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0015 SNMP_RO" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0016 SQL_Browser" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mssql/browser/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mssql/browser/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0017 SMB_shares" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0017 SMB_Users" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/users.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/smb/anonymous_enumeration/users.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0021 FTP_Anonymous" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ftp/anonymous/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ftp/anonymous/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0030 SSH Root password login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ssh/root_login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ssh/root_login/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0037 FTP_Unencrypted" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ftp/unencrypted/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ftp/unencrypted/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0038 MySQL_Login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mysql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mysql/login/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0056 MSRPC_Fuzzing" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/fuzzing/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rpc/fuzzing/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0057 Weak_Cipher" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/tls/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/web/tls/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0063 MSSQL_login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mssql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mssql/login/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0064 PostgreSql_login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/postgresql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/postgresql/login/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0010 SSDP_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ssdp/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ssdp/amplification/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0058 Minolta_Password_Extract" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/printer/extract/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/printer/extract/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0059 SNMP_V1V2" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/snmp/v1_v2c/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/snmp/v1_v2c/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TW-2021-0024 IIS_Tilde/Shortname" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/iis_tilde/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/iis_tilde/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0039 IMAP" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/mail/imap/unencrypted/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/mail/imap/unencrypted/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0070 POP3" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/mail/pop3/unencrypted/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/mail/pop3/unencrypted/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0013 Printer_access" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/printer/access/msf_*_printer.txt >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/loot/intern/printer/access/msf_*_printer.txt | cut -c2- | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0071 Portmap_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/amplification/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0072 Endpointmap" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/endpointmap/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/endpointmap/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0073 RPC_Portmap" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/portmapper/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rpc/portmapper/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0010 BlueKeep" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/bluekeep/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rdp/bluekeep/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0011 EternalBlue" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/eternal_blue/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/smb/eternal_blue/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0040 HP iLO Bypass" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/ilo/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/ilo/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2020-0041 ZeroLogon" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/zero_logon/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/zero_logon/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0003 NTP_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ntp/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/ntp/amplification/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0032 MS12-020" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/ms12-020/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rdp/ms12-020/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0060 SSH_Depricated" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/ssh_depricated/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/ssh_depricated/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0061 VMWARE_VSAN" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/vmware/vsan/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/vmware/vsan/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0062 SSH_eol" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/ssh/openssh_version.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/ssh/openssh_version.txt | cut -d " " -f 2 | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0062 Windows_eol" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/windows/windows_versions.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/windows/windows_versions.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0063 VMWARE_OVA" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/vmware/ova/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/vmware/ova/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TW-2021-0009 MS15-034" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/ms15-034/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/ms15-034/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TW-2021-0010 IIS_Bypass" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/iis_bypass/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/iis_bypass/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0065 VMWARE_CEIP" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/vmware/ceip/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/vmware/ceip/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PS-TN-2021-0029 DNS_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/dns/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/dns/amplification/hosts.txt | cut -d . -f 1,2,3 | sort -u | sed 's/$/.0\/24/' >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Devices" >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/list/msf_hosts.txt | wc -l >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt
echo "Services" >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/list/msf_services.txt | wc -l >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Done"
exit 0
