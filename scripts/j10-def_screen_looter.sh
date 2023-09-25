#!/bin/bash

figlet DefScreenLooter

{
  echo "Start def_screen_lootcollector"
  date
} >>/root/output/runtime.txt

### Default pages
grep -l -e '<title>Microsoft Internet Information Services 8</title>' -e '<title>IIS7</title>' -e '<title>IIS Windows Server</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/web/iis/hosts.txt
grep -l -e '<title>Welcome to JBoss Application Server' -e '<title>Welcome to WildFly' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/web/jboss/hosts.txt
grep -l -e '<title>Apache2 Ubuntu Default Page: It works</title>' -e '<title>Apache2 Debian Default Page: It works</title>' -e '<title>HTTP Server Test Page powered by CentOS</title>' -e '<title>Oracle HTTP Server Index</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/web/httpd/hosts.txt
grep -l -e '<title>Welcome to nginx!</title>' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/web/nginx/hosts.txt
grep -l -e '<title>Apache Tomcat' /root/output/screens/source/*.txt | sed 's%.*[http|https]\.%%g' | sed 's/\.txt//g' | cut -d '.' -f 1,2,3,4 | sort -u >/root/output/loot/web/tomcat/hosts.txt

### counter for findings.txt
{
  echo "PS-TN-2020-0018 IIS default page"
  wc -l /root/output/loot/web/iis/hosts.txt
  cut -d . -f 1,2,3 /root/output/loot/web/iis/hosts.txt | sort -u | sed 's/$/.0\/24/'
  echo ""

  echo "PS-TN-2021-0031 JBOSS default page"
  wc -l /root/output/loot/web/jboss/hosts.txt
  cut -d . -f 1,2,3 /root/output/loot/web/jboss/hosts.txt | sort -u | sed 's/$/.0\/24/'
  echo ""

  echo "PS-TW-2021-0006 httpd default page"
  wc -l /root/output/loot/web/httpd/hosts.txt
  cut -d . -f 1,2,3 /root/output/loot/web/httpd/hosts.txt | sort -u | sed 's/$/.0\/24/'
  echo ""

  echo "PS-TW-2021-0008 nginx default page"
  wc -l /root/output/loot/web/nginx/hosts.txt
  cut -d . -f 1,2,3 /root/output/loot/web/nginx/hosts.txt | sort -u | sed 's/$/.0\/24/'
  echo ""

  echo "PS-TN-2020-0024 Tomcat default page"
  wc -l /root/output/loot/web/tomcat/hosts.txt
  cut -d . -f 1,2,3 /root/output/loot/web/tomcat/hosts.txt | sort -u | sed 's/$/.0\/24/'
  echo ""
} >>/root/output/findings.txt

{
  echo 'END DefScreenLooter'
  date
} >>/root/output/runtime.txt
echo 'END DefScreenLooter'
