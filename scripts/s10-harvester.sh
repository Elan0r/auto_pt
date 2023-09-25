#!/bin/bash

figlet Harvest

read -e -r -p 'File with Domains for Harvest (no http/https): ' HOSTS
if [ -z "$HOSTS" ]; then
  echo -e '! >set File!'
  exit 1
else
  if [ -s "$HOSTS" ]; then
    echo '! >FILE OK '
  else
    echo "! >>NO File"
    exit 1
  fi
fi

{
  echo "Start Harvester"
  date
} >>/root/output/runtime.txt
for i in $(cat "$HOSTS"); do
  theHarvester -d "$i" -n -t -c -b all | tee -a /root/output/loot/harvest/"$i".txt
done

#Hosts for Scope
awk '/\[*\] Hosts found:/,(0 || /\[*\]/&&!/\[*\] Hosts/)' /root/output/loot/harvest/*.txt | grep -v '\[*\] ' | grep -v '\-\-\-' >>/root/output/loot/harvest/hosts.txt
#grep ':[0-9]\{1,3\}' /root/output/loot/harvest/hosts.txt | cut -d : -f 2 | sort -u >/root/output/loot/harvest/host_ip.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /root/output/loot/harvest/hosts.txt | sort -u >>/root/output/loot/harvest/host_ip.txt

#Emails
awk '/\[*\] Emails found:/,/\[*\]/&&!/\[*\] Emails/' /root/output/loot/harvest/*.txt | grep -v '\[*\].*Hosts' >>/root/output/loot/harvest/emails.txt

#Trello
awk '/\[*\] Trello URLs found:/,/\[*\]/&&!/\[*\] Trello/' /root/output/loot/harvest/*.txt | grep -v '\[*\].*IPs' >>/root/output/loot/harvest/trello.txt

{
  echo "Harvester Done"
  date
} >>/root/output/runtime.txt
echo "END Harvester"
