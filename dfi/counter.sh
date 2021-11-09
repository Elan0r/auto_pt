#!/bin/bash
figlet -w 94 ProSecCounter

echo "smb_signing" > /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/smb_signing/hosts.txt >> /root/output/loot/intern//findings.txt
cat  /root/output/loot/intern/smb/smb_signing/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SMB_v1" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/smb_v1/hosts.txt >> /root/output/loot/intern//findings.txt
cat  /root/output/loot/intern/smb/smb_v1/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "RDP_NLA" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/nla/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rdp/nla/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "NetBIOS_Information Disclosure" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ad/netbios/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ad/netbios/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Telnet" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/telnet/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/telnet/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "IPMI_Cipher" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ipmi/zero_cipher/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ipmi/zero_cipher/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "IPMI_Hash" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ipmi/hashdump/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ipmi/hashdump/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SNMP_RO" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/snmp/community_string/hosts_default_community_ro.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SQL_Browser" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mssql/browser/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mssql/browser/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SMB_shares" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/smb/anonymous_enumeration/smb_shares.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SMB_Users" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/users.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/smb/anonymous_enumeration/users.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "FTP_Anonymous" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ftp/anonymous/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ftp/anonymous/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "FTP_Unencrypted" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ftp/unencrypted/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ftp/unencrypted/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "MySQL_Login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mysql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mysql/login/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "RPC_Fuzzing" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/fuzzing/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rpc/fuzzing/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "MSSQL_login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/mssql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/mssql/login/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "PostgreSql_login" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/database/postgresql/login/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/database/postgresql/login/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SSDP_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ssdp/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ssdp/amplification/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Minolta_Password_Extract" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ssdp/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/ssdp/amplification/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SNMP_V1V2" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/snmp/v1_v2c/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/snmp/v1_v2c/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "RPC_Portmap" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/portmaper/hosts.txt >> /root/output/loot/intern/findings.txt
cat  /root/output/loot/intern/rpc/portmaper/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Printer_access" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/printer/access/msf_*_printer.txt >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/loot/intern/printer/access/msf_*_printer.txt | cut -c2- | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Portmap_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/amplification/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Endpointmap" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/endpointmap/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/endpointmap/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "BlueKeep" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/bluekeep/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rdp/bluekeep/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "EternalBlue" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/smb/eternal_blue/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/smb/eternal_blue/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "ZeroLogon" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rpc/zerologon/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rpc/zerologon/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "NTP_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/ntp/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/ntp/amplification/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "MS12-020" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/rdp/ms12-020/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/rdp/ms12-020/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "VMWARE_VSAN" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/vmware/vsan/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/vmware/vsan/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "VMWARE_OVA" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/vmware/ova/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/vmware/ova/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "MS15-034" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/ms15-034/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/ms15-034/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "IIS_Bypass" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/iis_bypass/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/web/iis_bypass/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SSE_Depricated" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/ssh_depricated/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/ssh_depricated/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "SSH_eol" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/ssh/openssh_version.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/ssh/openssh_version.txt | cut -d " " -f 2 | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Windows_eol" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/eol/windows/windows_versions.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/eol/windows/windows_versions.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "DNS_Amp" >> /root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/dns/amplification/hosts.txt >> /root/output/loot/intern/findings.txt
cat /root/output/loot/intern/dns/amplification/hosts.txt | cut -d . -f 1,2,3 |sort -u >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Devices" >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/list/msf_hosts.txt | wc -l >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt
echo "Services" >> /root/output/loot/intern/findings.txt
tail -n +2 /root/output/list/msf_services.txt | wc -l >> /root/output/loot/intern/findings.txt
echo "" >> /root/output/loot/intern/findings.txt

echo "Done"
exit 0
