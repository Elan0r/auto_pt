#!/bin/bash
figlet -w 96 ProSecScoper
echo 'version 1.1'
echo -e ''

read -e -p 'File with Domains for Scope Check (no http/https): ' HOSTS
if [ -z "$HOSTS" ];
then
	echo -e '! > set File!'
	exit 1
else
	if [ -s $HOSTS ]; then
    	echo '! > FILE OK '
	else
   		echo "! >> NO File"
		exit 1
	fi
fi

echo -e ''
read -e -p 'Where to save?;will create output/harvest folder inside: ' RFOLDER

FOLDER=$(echo $RFOLDER | sed 's:/*$::')

if [[ -z $FOLDER || $FOLDER == "." ]] 
then
	FOLDER=$PWD
    echo -e '! > Folder is '$FOLDER
else
	if [ ! -d $FOLDER/output/harvest ]
	then
		mkdir -p $FOLDER/output/harvest
		echo -e '! > Folder Created at '$FOLDER'/output/harvest'
	else
		echo -e '! > Folder OK!'
	fi
fi

for i in $(cat $HOSTS)
do
  theHarvester -d $i -n -c -b all | tee -a $FOLDER/output/harvest/$i.txt
done
#Hosts for Scope
awk '/\[*\] Hosts found:/,(0 || /\[*\]/&&!/\[*\] Hosts/)' $FOLDER/output/harvest/*.txt | grep -v '\[*\] ' | grep -v '\-\-\-' > $FOLDER/output/harvest/hosts.txt
#grep ':[0-9]\{1,3\}' $FOLDER/output/harvest/hosts.txt | cut -d : -f 2 | sort -u > $FOLDER/output/harvest/host_ip.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $FOLDER/output/harvest/hosts.txt | sort -u > $FOLDER/output/harvest/host_ip.txt

#Emails
awk '/\[*\] Emails found:/,/\[*\]/&&!/\[*\] Emails/' $FOLDER/output/harvest/*.txt | grep -v '\[*\].*Hosts' > $FOLDER/output/harvest/emails.txt

#Trello

awk '/\[*\] Trello URLs found:/,/\[*\]/&&!/\[*\] Trello/' $FOLDER/output/harvest/*.txt | grep -v '\[*\].*IPs' > $FOLDER/output/harvest/trello.txt

exit 0
