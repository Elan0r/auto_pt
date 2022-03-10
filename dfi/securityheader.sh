#!/bin/bash
figlet -w 105 ProSecSecurityHeader
echo -e ''
read -p 'File with Domains/IPs for Headercheck (no http/https): ' file

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
read -p 'Where to save?: ' folder
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
	echo -e "Server: $i" | tee $folder/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd http://$i | tee -a $folder/header_$i.txt
	python3 /opt/shcheck/shcheck.py -ixkd https://$i | tee -a $folder/header_$i.txt
done
exit 0
