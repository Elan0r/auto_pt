#!/bin/bash

figlet SecurityHeader

read -e -r -p 'File with Domains/IPs for Headercheck (no http/https): ' HOSTS
if [ -z "$HOSTS" ]; then
  echo -e '! >set File!'
  exit 1
else
  if [ ! -s "$HOSTS" ]; then
    echo "! >>NO File"
    exit 1
  fi
fi

{
  echo "Start Header Check"
  date
} >>/root/output/runtime.txt
for i in $(cat "$HOSTS"); do
  echo -e "Server: $i" | tee /root/output/loot/web/header/raw/header_"$i".txt
  shcheck.py -ixd http://"$i" | tee -a /root/output/loot/web/header/raw/header_"$i".txt
  shcheck.py -ixd https://"$i" | tee -a /root/output/loot/web/header/raw/header_"$i".txt
done

#Server disclosure
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /Server/' "$i" >>/root/output/loot/web/header/raw/tmpserver.txt
done
grep -B1 'IIS\|Apache/\|nginx/' /root/output/loot/web/header/raw/tmpserver.txt | sed -r 's/Server: //' >/root/output/loot/web/header/server.txt

#X-Powered-By
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /X-Powered/' "$i" >>/root/output/loot/web/header/raw/tmpxpwr.txt
done
grep -B1 'Value' /root/output/loot/web/header/raw/tmpxpwr.txt | sed -r 's/Server: //' >/root/output/loot/web/header/x-powered.txt

#X-XSS
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /X-XSS/' "$i" >>/root/output/loot/web/header/raw/tmpxss.txt
done
sed -e 's/\x1b\[[0-9;]*m//g' /root/output/loot/web/header/raw/tmpxss.txt | grep -B1 'Missing\|\(Value: 0\)' | sort -u | sed -r 's/Server: //' >/root/output/loot/web/header/xss.txt

#Strict-Transport
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /Strict-Transport/' "$i" >>/root/output/loot/web/header/raw/tmphsts.txt
done
grep -B1 'Missing' /root/output/loot/web/header/raw/tmphsts.txt | sort -u | sed -r 's/Server: //' >/root/output/loot/web/header/hsts.txt

#Content-Security
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /Content-Security/' "$i" >>/root/output/loot/web/header/raw/tmpcsp.txt
done
grep -B1 'Missing' /root/output/loot/web/header/raw/tmpcsp.txt | sort -u | sed -r 's/Server: //' >/root/output/loot/web/header/csp.txt

#X-Frame Options
for i in /root/output/loot/web/header/raw/header_*.txt; do
  [[ -e "$i" ]] || break
  awk 'NR==1 || /X-Frame/' "$i" >>/root/output/loot/web/header/raw/tmpxframe.txt
done
grep -B1 'Missing' /root/output/loot/web/header/raw/tmpxframe.txt | sort -u | sed -r 's/Server: //' >/root/output/loot/web/header/x-frame.txt

#TMP cleanup
rm /root/output/loot/web/header/raw/tmp*

{
  echo "HSTS"
  wc -l /root/output/loot/web/header/hsts.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/header/hsts.txt
  echo ""
  echo "CSP"
  wc -l /root/output/loot/web/header/csp.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/header/csp.txt
  echo ""
  echo "X-Frame-Options"
  wc -l /root/output/loot/web/header/x-frame.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/header/x-frame.txt
  echo ""
  echo "X-Powered-by"
  wc -l /root/output/loot/web/header/x-powered.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/header/x-powered.txt
  echo ""
  echo "Server"
  wc -l /root/output/loot/web/header/server.txt
  sed -z 's/\n/,/g; s/,$/\n/' /root/output/loot/web/header/server.txt
  echo ""
} >>/root/output/findings.txt

{
  echo "END Header Check"
  date
} >>/root/output/runtime.txt
echo "END Header Check"
