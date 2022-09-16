#!/bin/bash
figlet ProSecSlowHTTP
echo 'version 1.1'
echo -e ''

read -e -p 'File with Domains for SlowHTTP (no http/https): ' HOSTS
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
read -e -p 'Where to save?; will create output/slowhttp folder inside: ' RFOLDER

FOLDER=$(echo $RFOLDER | sed 's:/*$::')

if [[ -z $FOLDER || $FOLDER == "." ]] 
then
	FOLDER=$PWD
    echo -e '! > Folder is '$FOLDER
else
	if [ ! -d $FOLDER/output/slowhttp ]
	then
		mkdir -p $FOLDER/output/slowhttp
		echo -e '! > Folder Created at '$FOLDER/output/slowhttp
	else
		echo -e '! > Folder OK!'
	fi
fi

echo -e ''
read -p 'Test Time in SECONDS (default 10) : ' time
if [ -z "$time" ];
then
	time=10
	echo -e '! > Time = '$time
else
	echo -e '! > Time = '$time
fi

for i in $(cat $HOSTS) 
do 
slowhttptest -l $time -g -o $FOLDER/output/slowhttp/$i -u https://$i -c 9999 -r 2000 -b 240
sleep 5 
done

exit 0
