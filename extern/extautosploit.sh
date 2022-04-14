#!/bin/bash

figlet -w 95 ProSecExtAutoSploit

read -e -p 'Path to Resource_script "extern.txt" from hacking Repo: ' RES
if [ -z $RES ]
then
    echo '! > extern.txt missing here: '$RES
    exit 1
fi

read -e -p 'File with Domains for MSF run (no http/https): ' HOSTS
if [ -z $HOSTS ]
then
    echo 'supply File!'
    exit 1
fi

read -e -p 'Where to save? (no end / ) will create "output" folder inside: ' FOLDER
if [[ -z $FOLDER || $FOLDER == "." || $FOLDER == "./" ]] 
then
	FOLDER=$PWD
    echo -e '! > Folder is '$FOLDER
else
	if [ ! -d $FOLDER ]
	then
		mkdir -p $FOLDER
		echo -e '! > Folder Created at '$FOLDER
	else
		echo -e '! > Folder OK!'
	fi
fi

mkdir -p $FOLDER/output/msf $FOLDER/output/nmap

read -p "Enter Workspace Name (will delete if exists): " WS
if [ -z $WS ]
then
    WS=new
    echo 'Workspace will be '$WS
fi

echo 'workspace -d ' $WS > $FOLDER/output/msf/workspace.txt
echo 'workspace -a ' $WS >> $FOLDER/output/msf/workspace.txt
echo 'db_import '$FOLDER'/output/nmap/service.xml' >> $FOLDER/output/msf/workspace.txt

nmap -sSV -n -Pn --max-retries 5 -oA $FOLDER/output/nmap/service -iL $HOSTS

sed -e "s%spool /root%spool $FOLDER%g" $RES > $FOLDER/output/msf/tmp.txt
sed -e "s%services.*%set rhosts file:$HOSTS" $FOLDER/output/msf/tmp.txt  > $FOLDER/output/msf/resource.txt

msfdb init
msfconsole -qx "resource "$FOLDER"/output/msf/workspace.txt "$FOLDER"/output/msf/resource.txt"  > /dev/null 2>&1

echo 'looting'

### FTP
mkdir -p $FOLDER/output/extern/ftp/anonymous
awk '/Anonymous READ/ {print$2}' $FOLDER/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/extern/ftp/anonymous/hosts.txt
mkdir -p $FOLDER/output/extern/ftp/unencrypted
awk '/FTP Banner/ {print$2}' $FOLDER/output/msf/ftp.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/extern/ftp/unencrypted/hosts.txt

### IIS
mkdir -p $FOLDER/output/extern/web/iis_bypass
grep -B 1 'You can bypass auth' $FOLDER/output/msf/web.txt | awk '/against/ {print$5}' | sort -u > $FOLDER/output/extern/web/iis_bypass/hosts.txt
mkdir -p $FOLDER/output/extern/web/ms15-034
awk '/The target is vulnerable/{print$2}' $FOLDER/output/msf/web.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/extern/web/ms15-034/hosts.txt
mkdir -p $FOLDER/output/extern/web/iis_tilde
awk '/The target is vulnerable/{print$2}' $FOLDER/output/msf/iis_tilde.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/extern/web/iis_tilde/hosts.txt

### log4shell
mkdir -p $FOLDER/output/extern/web/log4shell
awk '/Log4Shell found/{print$2}' $FOLDER/output/msf/log4j.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/extern/web/log4shell/hosts.txt

figlet AllDone!

exit 0
