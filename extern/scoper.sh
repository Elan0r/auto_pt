#!/bin/bash
figlet -w 96 ProSecScoper

echo -e ''
read -e -p 'File with Domains for Scope Check (no http/https): ' file
if [ -z "$file" ];
then
	echo -e '! > set File!'
	exit 1
else
	if [ -s $file ]; then
    	echo '! > FILE OK '
	else
   		echo "! >> NO File"
		exit 1
	fi
fi

echo -e ''
read -e -p 'Where to save? (no end / ): ' folder
if [ -z "$folder" ];
then
	echo -e '! > set Folder!'
	exit 1
else
	if [ ! -d $folder ]
	then
		mkdir -p $folder
		echo -e '! > Folder Created at '$folder
	else
		echo -e '! > Folder OK!'
	fi
fi

for i in $(cat $file)
do
  theHarvester -d $i -n -c -b all | tee -a $folder/harvest_$i.txt
done
#Hosts for Scope
awk '/\[*\] Hosts found:/,(0 || /\[*\]/&&!/\[*\] Hosts/)' $folder/harvest_*.txt | grep -v '\[*\] Starting' | sed '/Hosts found:/d2g' > $folder/hosts.txt
#grep ':[0-9]\{1,3\}' $folder/hosts.txt | cut -d : -f 2 | sort -u > $folder/host_ip.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $folder/hosts.txt | sort -u > $folder/host_ip.txt

#Emails
awk '/\[*\] Emails found:/,/\[*\]/&&!/\[*\] Emails/' $folder/harvest_*.txt | grep -v '\[*\].*Hosts' > $folder/emails.txt

#Trello

awk '/\[*\] Trello URLs found:/,/\[*\]/&&!/\[*\] Trello/' $folder/harvest_*.txt | grep -v '\[*\].*IPs' > $folder/trello.txt

exit 0
