#!/bin/bash
figlet -w 105 ProSecSecurityHeader
echo -e ''
read -e -p 'File with Domains/IPs for Headercheck (no http/https): ' file

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
read -e -p 'Where to save? (no end / ; will create header folder inside): ' folder
if [ -z "$folder" ];
then
	echo -e '! > set Folder!'
	exit 1
else
	if [ ! -d $folder/header ]
	then
		mkdir -p $folder/header
		echo -e '! > Folder Created at '$folder'/header'
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

for i in $(cat $file)
do
	echo -e "Server: $i" | tee $folder/header/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd http://$i | tee -a $folder/header/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd https://$i | tee -a $folder/header/header_$i.txt
done

#looting for findings & Automater
#Server disclosure
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /Server/' $i >> $folder/header/tmpserver.txt
done
grep -B1 'IIS\|Apache/\|nginx/' $folder/header/tmpserver.txt | sed -r 's/Server: //' > $folder/header/server.txt

#X-Powered-By
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /X-Powered/' $i >> $folder/header/tmpxpwr.txt
done
grep -B1 'Value' $folder/header/tmpxpwr.txt | sed -r 's/Server: //' > $folder/header/x-powered.txt

#X-XSS
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /X-XSS/' $i >> $folder/header/tmpxss.txt
done
cat $folder/header/tmpxss.txt | sed -e 's/\x1b\[[0-9;]*m//g' | grep -B1 'Missing\|\(Value: 0\)'  | sort -u | sed -r 's/Server: //' > $folder/header/xss.txt

#Strict-Transport
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /Strict-Transport/' $i >> $folder/header/tmphsts.txt
done
grep -B1 'Missing' $folder/header/tmphsts.txt | sort -u | sed -r 's/Server: //' > $folder/header/hsts.txt

#Content-Security
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /Content-Security/' $i >> $folder/header/tmpcsp.txt
done
grep -B1 'Missing' $folder/header/tmpcsp.txt | sort -u | sed -r 's/Server: //' > $folder/header/csp.txt

#X-Frame Options
for i in $(ls $folder/header/header_*.txt)
do 
	awk 'NR==1 || /X-Frame/' $i >> $folder/header/tmpxframe.txt
done
grep -B1 'Missing' $folder/header/tmpxframe.txt | sort -u | sed -r 's/Server: //' > $folder/header/x-frame.txt

exit 0
