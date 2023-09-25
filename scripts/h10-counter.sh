#!/bin/bash

figlet Counter

{
  echo "Start Finding Counter"
  date
} >>/root/output/runtime.txt

{
  ### SMB
  echo "SMB_Signing" >/root/output/findings.txt
  wc -l /root/output/loot/smb/smb_signing/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/smb/smb_signing/hosts.txt
  echo ""

  echo "SMB_shares"
  wc -l /root/output/loot/smb/anonymous_enumeration/smb_shares.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/smb/anonymous_enumeration/smb_shares.txt
  echo ""

  echo "SMB_Users"
  wc -l /root/output/loot/smb/anonymous_enumeration/users.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/smb/anonymous_enumeration/users.txt
  echo ""

  echo "SMB_v1"
  wc -l /root/output/loot/smb/smb_v1/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/smb/smb_v1/hosts.txt
  echo ""

  echo "EternalBlue"
  wc -l /root/output/loot/smb/eternal_blue/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/smb/eternal_blue/hosts.txt
  echo ""

  echo "Windows_eol"
  wc -l /root/output/loot/eol/windows/windows_versions.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/eol/windows/windows_versions.txt
  echo ""

  ###TELNET
  echo "Telnet"
  wc -l /root/output/loot/network/telnet/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/network/telnet/hosts.txt
  echo ""

  echo "Lantronix_login"
  wc -l /root/output/loot/creds/lantronix/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/creds/lantronix/hosts.txt
  echo ""

  ###SSH
  echo "SSH_Depricated"
  wc -l /root/output/loot/eol/ssh_depricated/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/eol/ssh_depricated/hosts.txt
  echo ""

  echo "SSH_eol"
  wc -l /root/output/loot/eol/ssh/openssh_version.txt
  cut -d " " -f 2 /root/output/loot/eol/ssh/openssh_version.txt | sed -z 's/\n/,/g; s/,$/\n/'
  echo ""

  echo "SSH_login"
  wc -l /root/output/loot/network/ssh/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/network/ssh/hosts.txt
  echo ""

  ###IPMI
  echo "IPMI_Cipher0"
  wc -l /root/output/loot/ipmi/zero_cipher/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/ipmi/zero_cipher/hosts.txt
  echo ""

  echo "IPMI_Hashdump"
  wc -l /root/output/loot/ipmi/hashdump/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/ipmi/hashdump/hosts.txt
  echo ""

  ###SNMP
  echo "SNMP"
  wc -l /root/output/loot/network/snmp/hosts_default_community_ro.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/network/snmp/hosts_default_community_ro.txt
  echo ""

  ###FTP
  echo "FTP_Anonymous"
  wc -l /root/output/loot/network/ftp/anonymous/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/network/ftp/anonymous/hosts.txt
  echo ""

  echo "FTP_Unencrypted"
  wc -l /root/output/loot/network/ftp/unencrypted/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/network/ftp/unencrypted/hosts.txt
  echo ""

  ###Database
  echo "MSSQL_Browser"
  wc -l /root/output/loot/database/mssql/browser/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/database/mssql/browser/hosts.txt
  echo ""

  echo "MSSQL_login"
  wc -l /root/output/loot/database/mssql/login/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/database/mssql/login/hosts.txt
  echo ""

  echo "MySQL_Login"
  wc -l /root/output/loot/database/mysql/login/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/database/mysql/login/hosts.txt
  echo ""

  echo "PostgreSql_login"
  wc -l /root/output/loot/database/postgresql/login/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/database/postgresql/login/hosts.txt
  echo ""

  echo "MongoDB_Login"
  wc -l /root/output/loot/database/mongodb/login/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/database/mongodb/login/hosts.txt
  echo ""

  echo "Printer_access"
  wc -l /root/output/loot/printer/access/msf_*_printer.txt
  tail -n +2 /root/output/loot/printer/access/msf_*_printer.txt | cut -c2- | sed -z '/^$/d; /msf_/d; s/\n/,/g; s/,$/\n/'
  echo ""

  echo "Minolta_Password_Extract"
  wc -l /root/output/loot/printer/extract/hosts.txt
  cut -d ":" -f 4 /root/output/loot/printer/extract/hosts.txt | sed -z 's/.*=//g; s/\n/,/g; s/,$/\n/'
  echo ""

  ###MAIL
  echo "IMAP"
  wc -l /root/output/loot/mail/imap/unencrypted/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/mail/imap/unencrypted/hosts.txt
  echo ""

  echo "POP3"
  wc -l /root/output/loot/mail/pop3/unencrypted/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/mail/pop3/unencrypted/hosts.txt
  echo ""

  ###RPC
  echo "RPC_Portmap"
  wc -l /root/output/loot/rpc/portmapper/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rpc/portmapper/hosts.txt
  echo ""

  echo "RPC_Portmap_Amp"
  wc -l /root/output/loot/rpc/amplification/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rpc/amplification/hosts.txt
  echo ""

  echo "NFS_share"
  wc -l /root/output/loot/rpc/nfs/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rpc/nfs/hosts.txt
  echo ""

  echo "ZeroLogon"
  wc -l /root/output/loot/rpc/zero_logon/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rpc/zero_logon/hosts.txt
  echo ""

  ###RDP
  echo "RDP_NLA"
  wc -l /root/output/loot/rdp/nla/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rdp/nla/hosts.txt
  echo ""

  echo "BlueKeep"
  wc -l /root/output/loot/rdp/bluekeep/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rdp/bluekeep/hosts.txt
  echo ""

  echo "MS12-020"
  wc -l /root/output/loot/rdp/ms12-020/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/rdp/ms12-020/hosts.txt
  echo ""

  ###VMware
  echo "VMWARE_VSAN"
  wc -l /root/output/loot/vmware/vsan/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/vmware/vsan/hosts.txt
  echo ""

  echo "VMWARE_VMDIR"
  wc -l /root/output/loot/vmware/vmdir/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/vmware/vmdir/hosts.txt
  echo ""

  echo "VMWARE_OVA"
  wc -l /root/output/loot/vmware/ova/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/vmware/ova/hosts.txt
  echo ""

  echo "VMWARE_CEIP"
  wc -l /root/output/loot/vmware/ceip/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/vmware/ceip/hosts.txt
  echo ""

  echo "VMWARE_Log4Shell"
  wc -l /root/output/loot/vmware/log4shell/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/vmware/log4shell/hosts.txt
  echo ""

  ###IIS
  echo "IIS_Tilde/Shortname"
  wc -l /root/output/loot/web/iis_tilde/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/iis_tilde/hosts.txt
  echo ""

  echo "MS15-034_HTTP_dump"
  wc -l /root/output/loot/web/ms15-034/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/ms15-034/hosts.txt
  echo ""

  echo "IIS_Auth_Bypass"
  wc -l /root/output/loot/web/iis_bypass/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/iis_bypass/hosts.txt
  echo ""

  ###WEB
  echo "Log4Shell"
  wc -l /root/output/loot/web/log4shell/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/log4shell/hosts.txt
  echo ""

  echo "Heartbleed"
  wc -l /root/output/loot/web/tls/heartbleed/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/tls/heartbleed/hosts.txt
  echo ""

  echo "HP_iLO_Auth_Bypass"
  wc -l /root/output/loot/web/ilo/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/ilo/hosts.txt
  echo ""

  ###DNS
  echo "DNS_Amp"
  wc -l /root/output/loot/dns/amplification/hosts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/dns/amplification/hosts.txt
  echo ""

  echo "Devices"
  tail -n +2 /root/output/list/msf_hosts.txt | wc -l
  echo ""
  echo "Services"
  tail -n +2 /root/output/list/msf_services.csv | wc -l
  echo ""
} >>/root/output/findings.txt

{
  echo "END Counting"
  date
} >>/root/output/runtime.txt
echo "END Counting"
