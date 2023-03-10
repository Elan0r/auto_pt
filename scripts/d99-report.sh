#!/bin/bash

figlet -w 99 InfoGatheringReport

echo 'Create Info Gathering Report' >>/root/output/runtime.txt
date >>/root/output/runtime.txt

#Info Gathering Summary File
cat /root/output/list/domainname.txt | sort -u >/root/output/info_gathering.txt
wc -l /root/output/list/domainname.txt >>/root/output/info_gathering.txt
echo 'Domains Found' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
cut -d . -f 1,2,3 /root/output/list/ipup.txt | sort -u | wc -l >>/root/output/info_gathering.txt
echo '/24 Networks detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/ipup.txt >>/root/output/info_gathering.txt
echo 'Hosts detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
grep -c ' open ' /root/output/nmap/service.nmap >>/root/output/info_gathering.txt
echo 'Services detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/winrm_all_open.txt >>/root/output/info_gathering.txt
echo 'WinRM Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/check_mk_open.txt >>/root/output/info_gathering.txt
echo 'CheckMK Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/smb_open.txt >>/root/output/info_gathering.txt
echo 'SMB Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/loot/intern/smb/anonymous_enumeration/cme_shares.txt >>/root/output/info_gathering.txt
echo 'SMB Anonymous READABLE Shares found' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/rdp_open.txt >>/root/output/info_gathering.txt
echo 'RDP Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/ldap_open.txt >>/root/output/info_gathering.txt
echo 'LDAP Ports detected' >>/root/output/info_gathering.txt
echo '' >>/root/output/info_gathering.txt
wc -l /root/output/list/kerberos_open.txt >>/root/output/info_gathering.txt
echo 'Kerberos Ports detected' >>/root/output/info_gathering.txt

echo 'END Info Gathering Report' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END Info Gathering Report'
