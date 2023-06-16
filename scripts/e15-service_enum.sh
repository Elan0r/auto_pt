#!/bin/bash

figlet ServiceEnum

#sslscan 4 weak cipher
if [ -s /root/output/msf/sslscan.txt ]; then
  echo '! >> SSL Scan already Done.'
else
  echo '! > Weak Ciphers Background Job start!'
  sslscan --targets=/root/output/list/ssl_open.txt >/root/output/msf/sslscan.txt 2>&1 &
fi

echo 'END SSL Check' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo 'END SSL Check'

echo 'NFS Mounts' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
#NFS mounts
nmap -Pn -sV --script=nfs-showmount,nfs-ls -iL /root/output/list/rpc_open.txt -oA /root/output/nmap/nfs >/dev/null 2>&1

echo 'MSSQL autokill' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
#MSSQL autokill
nmap --script broadcast-ms-sql-discover,ms-sql-*, --script-args=newtargets -iL /root/output/list/mssql_open.txt -oA /root/output/nmap/mssql_autokill >/dev/null 2>&1

echo 'MySQL autokill' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
#MySQL
nmap -Pn -sV --script=mysql-* -iL /root/output/list/mysql_open.txt -oA /root/output/nmap/mysql_autokill >/dev/null 2>&1

echo 'tftp enum' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
#tftp enum
nmap -Pn -sU -p 69 --script tftp-enum -iL /root/output/list/ipup.txt -oA /root/output/nmap/tftp_enum >/dev/null 2>&1

echo 'SSH proto v1' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
#SSH v1
nmap -Pn -sV -p 22 --script sshv1 -iL /root/output/list/ssh_open.txt -oA /root/output/nmap/sshv1 >/dev/null 2>&1
