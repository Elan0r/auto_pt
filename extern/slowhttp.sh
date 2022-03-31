#!/bin/bash
figlet ProSecSlowHTTP

echo -e ''
read -e -p 'File with Domains for SlowHTTP (no http/https): ' file
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

echo -e ''
read -p 'Test Time in SECONDS (default 10) : ' time
if [ -z "$time" ];
then
	time=10
	echo -e '! > Time = '$time
else
	echo -e '! > Time = '$time
fi

for i in $(cat $file) 
do 
slowhttptest -l $time -g -o $folder/$i -u https://$i -c 9999 -r 2000 -b 240
sleep 5 
done

exit 0
