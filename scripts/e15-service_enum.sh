#!/bin/bash

figlet ServiceEnum

{
  echo 'SSL Check BG Task'
  date
} >>/root/output/runtime.txt

#sslscan 4 weak cipher
if [ ! -s /root/output/msf/sslscan.txt ]; then
  sslscan --targets=/root/output/list/ssl_open.txt >/root/output/msf/sslscan.txt 2>&1 &
fi

{
  echo 'NFS Mounts'
  date
} >>/root/output/runtime.txt
#NFS mounts
nmap -Pn -sV --script=nfs-showmount,nfs-ls -iL /root/output/list/rpc_open.txt -oA /root/output/nmap/nfs >/dev/null 2>&1

{
  echo 'MSSQL autokill'
  date
} >>/root/output/runtime.txt

#MSSQL autokill
if [ ! -s /root/output/msf/mssql_autokill.nmap ]; then
  nmap --script broadcast-ms-sql-discover,ms-sql-*, --script-args=newtargets -iL /root/output/list/mssql_open.txt -oA /root/output/nmap/mssql_autokill >/dev/null 2>&1
fi

{
  echo 'END MSSQL autokill'
  date
} >>/root/output/runtime.txt

{
  echo 'MySQL autokill'
  date
} >>/root/output/runtime.txt

#MySQL
if [ ! -s /root/output/msf/mysql_autokill.nmap ]; then
  nmap -Pn -sV --script=mysql-* -iL /root/output/list/mysql_open.txt -oA /root/output/nmap/mysql_autokill >/dev/null 2>&1
fi

{
  echo 'END MySQL autokill'
  date
} >>/root/output/runtime.txt

{
  echo 'tftp enum'
  date
} >>/root/output/runtime.txt

#tftp enum
if [ ! -s /root/output/msf/tftp_enum.nmap ]; then
  nmap -Pn -sU -p 69 --script tftp-enum -iL /root/output/list/ipup.txt -oA /root/output/nmap/tftp_enum >/dev/null 2>&1
fi

{
  echo 'END tftp enum'
  date
} >>/root/output/runtime.txt

{
  echo 'SSH proto v1'
  date
} >>/root/output/runtime.txt

#SSH v1
if [ ! -s /root/output/msf/tftp_enum.nmap ]; then
  nmap -Pn -sV -p 22 --script sshv1 -iL /root/output/list/ssh_open.txt -oA /root/output/nmap/sshv1 >/dev/null 2>&1
fi

{
  echo 'END SSH proto v1'
  date
} >>/root/output/runtime.txt
echo 'END Service Enum'
