#!/bin/bash
figlet ProSecLog4Shell
echo -e ''
read -p 'File with IPs for Log4Shell check (no http/https): ' file
echo -e ''
read -p 'Where to save?: ' folder

if [ ! -d $folder ]
then
	mkdir -p $folder
	echo -e '! > Folder Created at '$folder
else
	echo -e '! > Folder OK!'
fi

if [ -d /opt/log4jcheck ]; then
    cd /opt/log4jcheck
    git stash
    git pull
else
    cd /opt
    git clone https://gist.github.com/46661bc206d323e6770907d259e009b6.git
    mv 46661bc206d323e6770907d259e009b6 log4jcheck
    pip3 install requests
fi

for i in $(cat $file)
do
	echo -e "Server: $i" | tee $folder/jog4j_$i.txt
	python3 /opt/log4jcheck/log4j_rce_check.py --timeout 3 http://$i | tee -a $folder/log4j_$i.txt
	python3 /opt/log4jcheck/log4j_rce_check.py --timeout 3 https://$i | tee -a $folder/log4j_$i.txt
done
exit 0
