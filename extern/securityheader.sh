#!/bin/bash
figlet -w 105 ProSecSecurityHeader
echo 'version 1.1'
echo -e ''

read -e -p 'File with Domains/IPs for Headercheck (no http/https): ' HOSTS
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
read -e -p 'Where to save?; will create output/header folder inside: ' RFOLDER

FOLDER=$(echo $RFOLDER | sed 's:/*$::')

if [[ -z $FOLDER || $FOLDER == "." ]] 
then
	FOLDER=$PWD
    echo -e '! > Folder is '$FOLDER
else
	if [ ! -d $FOLDER/output/header ]
	then
		mkdir -p $FOLDER/output/header
		echo -e '! > Folder Created at '$FOLDER'/header'
	else
		echo -e '! > Folder OK!'
	fi
fi

if [ ! -d /opt/shcheck ]
then
	echo -e '! > shcheck not in /opt/shcheck'
	echo -e '! > Installing ...'
	cd /opt
	git clone https://github.com/santoru/shcheck.git
	cd /opt/shcheck
	python3 setup.py install
else
	echo -e '! > shcheck OK!'
fi

for i in $(cat $HOSTS)
do
	echo -e "Server: $i" | tee $FOLDER/output/header/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd http://$i | tee -a $FOLDER/output/header/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd https://$i | tee -a $FOLDER/output/header/header_$i.txt
done

#looting for findings & Automater
#Server disclosure
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /Server/' $i >> $FOLDER/output/header/tmpserver.txt
done
grep -B1 'IIS\|Apache/\|nginx/' $FOLDER/output/header/tmpserver.txt | sed -r 's/Server: //' > $FOLDER/output/header/server.txt

#X-Powered-By
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /X-Powered/' $i >> $FOLDER/output/header/tmpxpwr.txt
done
grep -B1 'Value' $FOLDER/output/header/tmpxpwr.txt | sed -r 's/Server: //' > $FOLDER/output/header/x-powered.txt

#X-XSS
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /X-XSS/' $i >> $FOLDER/output/header/tmpxss.txt
done
cat $FOLDER/output/header/tmpxss.txt | sed -e 's/\x1b\[[0-9;]*m//g' | grep -B1 'Missing\|\(Value: 0\)'  | sort -u | sed -r 's/Server: //' > $FOLDER/output/header/xss.txt

#Strict-Transport
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /Strict-Transport/' $i >> $FOLDER/output/header/tmphsts.txt
done
grep -B1 'Missing' $FOLDER/output/header/tmphsts.txt | sort -u | sed -r 's/Server: //' > $FOLDER/output/header/hsts.txt

#Content-Security
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /Content-Security/' $i >> $FOLDER/output/header/tmpcsp.txt
done
grep -B1 'Missing' $FOLDER/output/header/tmpcsp.txt | sort -u | sed -r 's/Server: //' > $FOLDER/output/header/csp.txt

#X-Frame Options
for i in $(ls $FOLDER/output/header/header_*.txt)
do 
	awk 'NR==1 || /X-Frame/' $i >> $FOLDER/output/header/tmpxframe.txt
done
grep -B1 'Missing' $FOLDER/output/header/tmpxframe.txt | sort -u | sed -r 's/Server: //' > $FOLDER/output/header/x-frame.txt

#tmp cleanup
rm $FOLDER/output/header/tmp*

exit 0
