#!/bin/bash

figlet -w 109 ProSecDefScreenLooter

echo "Start def_screen_lootcollector" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

### Default pages
grep -l -e '<title>Microsoft Internet Information Services 8</title>' -e '<title>IIS7</title>' -e '<title>IIS Windows Server</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/intern/web/iis/hosts.txt
grep -l -e '<title>Welcome to JBoss Application Server 7</title>' -e '<title>Welcome to WildFly</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/intern/web/jboss/hosts.txt
grep -l -e '<title>Apache2 Ubuntu Default Page: It works</title>' -e '<title>Apache2 Debian Default Page: It works</title>' -e '<title>HTTP Server Test Page powered by CentOS</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/intern/web/httpd/hosts.txt
grep -l -e '<title>Welcome to nginx!</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/intern/web/nginx/hosts.txt
grep -l -e '<title>Apache Tomcat' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/intern/web/tomcat/hosts.txt

### counter for findings.txt
echo "PS-TN-2020-0018 IIS default page" >>/root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/iis/hosts.txt >>/root/output/loot/intern/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/iis/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/loot/intern/findings.txt
echo "" >>/root/output/loot/intern/findings.txt

echo "PS-TN-2021-0031 JBOSS default page" >>/root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/jboss/hosts.txt >>/root/output/loot/intern/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/jboss/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/loot/intern/findings.txt
echo "" >>/root/output/loot/intern/findings.txt

echo "PS-TW-2021-0006 httpd default page" >>/root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/httpd/hosts.txt >>/root/output/loot/intern/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/httpd/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/loot/intern/findings.txt
echo "" >>/root/output/loot/intern/findings.txt

echo "PS-TW-2021-0008 nginx default page" >>/root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/nginx/hosts.txt >>/root/output/loot/intern/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/nginx/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/loot/intern/findings.txt
echo "" >>/root/output/loot/intern/findings.txt

echo "PS-TN-2020-0024 Tomcat default page" >>/root/output/loot/intern/findings.txt
wc -l /root/output/loot/intern/web/tomcat/hosts.txt >>/root/output/loot/intern/findings.txt
cut -d . -f 1,2,3 /root/output/loot/intern/web/tomcat/hosts.txt | sort -u | sed 's/$/.0\/24/' >>/root/output/loot/intern/findings.txt
echo "" >>/root/output/loot/intern/findings.txt

exit 0
