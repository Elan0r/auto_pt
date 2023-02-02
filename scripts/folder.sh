#!/bin/bash

mkdir -p /root/input/msf
mkdir -p /root/output/msf
mkdir -p /root/output/list/ot
mkdir -p /root/output/nmap/ot
mkdir -p /root/output/loot/hashes 
mkdir -p /root/output/loot/intern/snmp/community_string
mkdir -p /root/output/loot/intern/snmp/v1_v2c
mkdir -p /root/output/loot/intern/ftp/anonymous
mkdir -p /root/output/loot/intern/ftp/unencrypted
mkdir -p /root/output/loot/intern/eol/ssh
mkdir -p /root/output/loot/intern/eol/windows
mkdir -p /root/output/loot/intern/eol/ssh_depricated
mkdir -p /root/output/loot/intern/telnet/unencrypted
mkdir -p /root/output/loot/intern/smb/eternal_blue
mkdir -p /root/output/loot/intern/smb/smb_v1
mkdir -p /root/output/loot/intern/smb/smb_signing
mkdir -p /root/output/loot/intern/smb/anonymous_enumeration
mkdir -p /root/output/loot/intern/smb/permission_management
mkdir -p /root/output/loot/intern/smb/sensitive_information
mkdir -p /root/output/loot/intern/database/mssql/login
mkdir -p /root/output/loot/intern/database/postgresql/login
mkdir -p /root/output/loot/intern/database/mssql/browser
mkdir -p /root/output/loot/intern/database/mysql/login
mkdir -p /root/output/loot/intern/database/mongodb/login
mkdir -p /root/output/loot/intern/rpc/portmapper
mkdir -p /root/output/loot/intern/rpc/endpointmap
mkdir -p /root/output/loot/intern/rpc/fuzzing
mkdir -p /root/output/loot/intern/rpc/amplification
mkdir -p /root/output/loot/intern/rpc/zero_logon
mkdir -p /root/output/loot/intern/rpc/print_nightmare
mkdir -p /root/output/loot/intern/rpc/petit_potam
mkdir -p /root/output/loot/intern/rpc/null_sessions
mkdir -p /root/output/loot/intern/rpc/nfs
mkdir -p /root/output/loot/intern/rdp/bluekeep
mkdir -p /root/output/loot/intern/rdp/nla
mkdir -p /root/output/loot/intern/rdp/ms12-020
mkdir -p /root/output/loot/intern/ntp/amplification
mkdir -p /root/output/loot/intern/ad/netbios
mkdir -p /root/output/loot/intern/ad/kerberos/asreproast
mkdir -p /root/output/loot/intern/ad/kerberos/delegation
mkdir -p /root/output/loot/intern/ad/kerberos/kerberoasting
mkdir -p /root/output/loot/intern/ad/kerberos/krbtgt
mkdir -p /root/output/loot/intern/ad/kerberos/user_enum
mkdir -p /root/output/loot/intern/ad/kerberos/passwd_spray
mkdir -p /root/output/loot/intern/ad/laps
mkdir -p /root/output/loot/intern/ad/session
mkdir -p /root/output/loot/intern/ad/ntlm_auth
mkdir -p /root/output/loot/intern/ad/passpol
mkdir -p /root/output/loot/intern/ad/quota
mkdir -p /root/output/loot/intern/ad/user_description
mkdir -p /root/output/loot/intern/ad/gpp_password
mkdir -p /root/output/loot/intern/ad/gpp_autologin
mkdir -p /root/output/loot/intern/ad/remote_login_local_admin
mkdir -p /root/output/loot/intern/ad/adcs/esc8
mkdir -p /root/output/loot/intern/ad/adcs/esc2
mkdir -p /root/output/loot/intern/ad/adcs/esc1
mkdir -p /root/output/loot/intern/ad/local_admin
mkdir -p /root/output/loot/intern/ad/iam/rights
mkdir -p /root/output/loot/intern/ad/iam/gmsa
mkdir -p /root/output/loot/intern/ad/iam/password
mkdir -p /root/output/loot/intern/ad/iam/username
mkdir -p /root/output/loot/intern/ad/iam/privilege
mkdir -p /root/output/loot/intern/dns/amplification
mkdir -p /root/output/loot/intern/dns/tunnel
mkdir -p /root/output/loot/intern/dns/zone_transfer
mkdir -p /root/output/loot/intern/dns/filter
mkdir -p /root/output/loot/intern/ipmi/hashdump
mkdir -p /root/output/loot/intern/ipmi/zero_cipher
mkdir -p /root/output/loot/intern/mail/imap/unencrypted
mkdir -p /root/output/loot/intern/mail/pop3/unencrypted
mkdir -p /root/output/loot/intern/mail/smtp/open_relay
mkdir -p /root/output/loot/intern/mail/smtp/sender_restriction
mkdir -p /root/output/loot/intern/mail/smtp/starttls
mkdir -p /root/output/loot/intern/mail/smtp/unencrypted_auth
mkdir -p /root/output/loot/intern/mail/smtp/rdns
mkdir -p /root/output/loot/intern/ssdp/amplification
mkdir -p /root/output/loot/intern/printer/extract
mkdir -p /root/output/loot/intern/printer/access
mkdir -p /root/output/loot/intern/mitm/arp
mkdir -p /root/output/loot/intern/mitm/stp
mkdir -p /root/output/loot/intern/mitm/hsrp
mkdir -p /root/output/loot/intern/mitm/vrrp
mkdir -p /root/output/loot/intern/mitm/ipv6
mkdir -p /root/output/loot/intern/mitm/llmnr
mkdir -p /root/output/loot/intern/mitm/nbt
mkdir -p /root/output/loot/intern/mitm/routing
mkdir -p /root/output/loot/intern/mitm/wpad
mkdir -p /root/output/loot/intern/mitm/mdns
mkdir -p /root/output/loot/intern/network/egress_filtering
mkdir -p /root/output/loot/intern/network/icmp
mkdir -p /root/output/loot/intern/network/cdp
mkdir -p /root/output/loot/intern/network/dtp
mkdir -p /root/output/loot/intern/network/hps
mkdir -p /root/output/loot/intern/network/lldp
mkdir -p /root/output/loot/intern/network/stp
mkdir -p /root/output/loot/intern/network/vtp
mkdir -p /root/output/loot/intern/network/trunk
mkdir -p /root/output/loot/intern/network/client_isolation
mkdir -p /root/output/loot/intern/network/other_protocols
mkdir -p /root/output/loot/intern/network/clear_text
mkdir -p /root/output/loot/intern/network/segmentation_segregation
mkdir -p /root/output/loot/intern/network/host-based_firewall
mkdir -p /root/output/loot/intern/vmware/vsan
mkdir -p /root/output/loot/intern/vmware/vmdir
mkdir -p /root/output/loot/intern/vmware/ova
mkdir -p /root/output/loot/intern/vmware/vrops
mkdir -p /root/output/loot/intern/vmware/ceip
mkdir -p /root/output/loot/intern/vmware/log4shell
mkdir -p /root/output/loot/intern/voip/h323
mkdir -p /root/output/loot/intern/voip/sip
mkdir -p /root/output/loot/intern/voip/rtp
mkdir -p /root/output/loot/intern/ldap/signing
mkdir -p /root/output/loot/intern/ldap/nopac
mkdir -p /root/output/loot/intern/creds/lantronix
mkdir -p /root/output/loot/intern/creds/bmc
mkdir -p /root/output/loot/intern/creds/network
mkdir -p /root/output/loot/intern/creds/phone
mkdir -p /root/output/loot/intern/creds/printer
mkdir -p /root/output/loot/intern/creds/ups
mkdir -p /root/output/loot/intern/creds/san
mkdir -p /root/output/loot/intern/creds/web
mkdir -p /root/output/loot/intern/web/ilo
mkdir -p /root/output/loot/intern/web/iis_bypass
mkdir -p /root/output/loot/intern/web/ms15-034
mkdir -p /root/output/loot/intern/web/httpd
mkdir -p /root/output/loot/intern/web/iis
mkdir -p /root/output/loot/intern/web/tomcat
mkdir -p /root/output/loot/intern/web/jboss
mkdir -p /root/output/loot/intern/web/services
mkdir -p /root/output/loot/intern/web/index
mkdir -p /root/output/loot/intern/web/php
mkdir -p /root/output/loot/intern/web/nginx
mkdir -p /root/output/loot/intern/web/iis_tilde
mkdir -p /root/output/loot/intern/web/tls/heartbleed
mkdir -p /root/output/loot/intern/web/log4shell
mkdir -p /root/output/loot/intern/ssh/root_login
mkdir -p /root/output/loot/intern/monitoring/ids_ips

exit 0
