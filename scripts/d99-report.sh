#!/bin/bash

figlet -w 99 InfoGatheringReport

{
  echo 'Create Info Gathering Report'
  date
} >>/root/output/runtime.txt

#Info Gathering Summary File
{
  sort -u /root/output/list/domainname.txt
  sort -u /root/output/list/domainname.txt | wc -l
  echo 'Domains Found'
  echo ''
  cut -d . -f 1,2,3 /root/output/list/ipup.txt | sort -u | wc -l
  echo '/24 Networks detected'
  echo ''
  wc -l /root/output/list/ipup.txt
  echo 'Hosts detected'
  echo ''
  grep -c ' open ' /root/output/nmap/service.nmap
  echo 'Services detected'
  echo ''
  wc -l /root/output/list/winrm_all_open.txt
  echo 'WinRM Ports detected'
  echo ''
  wc -l /root/output/list/check_mk_open.txt
  echo 'CheckMK Ports detected'
  echo ''
  wc -l /root/output/list/smb_open.txt
  echo 'SMB Ports detected'
  echo ''
  wc -l /root/output/loot/smb/anonymous_enumeration/cme_shares.txt
  echo 'SMB Anonymous READABLE Shares found'
  echo ''
  wc -l /root/output/list/rdp_open.txt
  echo 'RDP Ports detected'
  echo ''
  wc -l /root/output/list/ldap_open.txt
  echo 'LDAP Ports detected'
  echo ''
  wc -l /root/output/list/ldaps_open.txt
  echo 'LDAPS Ports detected'
  echo ''
  wc -l /root/output/list/kerberos_open.txt
  echo 'Kerberos Ports detected'
} >/root/output/info_gathering.txt

{
  echo 'END Info Gathering Report'
  date
} >>/root/output/runtime.txt
echo 'END Info Gathering Report'
