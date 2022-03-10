#!/bin/bash
figlet -w 105 ProSecSecurityHeader
echo -e ''
read -p 'File with Domains/IPs for Headercheck (no http/https): ' file
echo -e ''
read -p 'Where to save?: ' folder

if [ -s $file ]; then
    echo '! > FILE OK '
else
    echo "! >> NO File"
	exit 1
fi

if [ ! -d $folder ]
then
	mkdir -p $folder
	echo -e '! > Folder Created at '$folder
else
	echo -e '! > Folder OK!'
fi

if [ ! -d /opt/shcheck ]
then
	echo -e '! > shcheck not in /opt/shcheck'
	exit 1
else
	echo -e '! > shcheck OK!'
fi

for i in $(cat $file)
do
	echo -e "Server: $i" | tee $folder/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd http://$i | tee -a $folder/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd https://$i | tee -a $folder/header_$i.txt
done
exit 0
