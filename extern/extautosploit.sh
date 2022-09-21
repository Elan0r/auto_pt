#!/bin/bash
figlet -w 95 ProSecExtAutoSploit
echo 'version 1.1'
echo -e ''

read -e -p 'File with Domains for MSF run (no http/https): ' HOSTS
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
read -e -p 'Where to save? will create "output" folder inside: ' RFOLDER

FOLDER=$(echo $RFOLDER | sed 's:/*$::')

if [[ -z $FOLDER || $FOLDER == "." ]] 
then
	FOLDER=$PWD
    echo -e '! > Folder is '$FOLDER
else
	if [ ! -d $FOLDER/output ]
	then
		mkdir -p $FOLDER/output
		echo -e '! > Folder Created at '$FOLDER
	else
		echo -e '! > Folder OK!'
	fi
fi


mkdir -p $FOLDER/output/ext_msf $FOLDER/output/nmap $FOLDER/output/loot/extern $FOLDER/output/nuclei

read -p "Enter Workspace Name (will delete if exists): " WS
if [ -z $WS ]
then
    WS=new
    echo 'Workspace will be '$WS
fi

read -p "Enter External IP: " IP

echo 'workspace -d ' $WS > $FOLDER/output/ext_msf/workspace.txt
echo 'workspace -a ' $WS >> $FOLDER/output/ext_msf/workspace.txt
echo 'db_import '$FOLDER'/output/nmap/ext_service.xml' >> $FOLDER/output/ext_msf/workspace.txt

echo 'Start Nmap'

nmap -sSVC -n -Pn --max-retries 5 -oA $FOLDER/output/nmap/ext_service -iL $HOSTS  > /dev/null 2>&1

#MSF Resource File
printf '%ssetg THREADS 150\nsetg VERBOSE true\nsetg SRVHOST '$IP'\n' > $FOLDER/output/ext_msf/resource.txt
#log4shell
printf '%s\nspool '$FOLDER'/output/ext_msf/log4j.txt\necho "log4j"\nuse auxiliary/scanner/http/log4shell_scanner\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nset ssl false\nrun\nsleep 5\nset rport 8080\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep5\nset rport 8443\nrun\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#proxyshell
printf '%s\nspool '$FOLDER'/output/ext_msf/mail.txt\necho "ProxyShell"\nuse auxiliary/scanner/http/exchange_proxylogon\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#IIS_Bypass
printf '%s\nspool '$FOLDER'/output/ext_msf/web.txt\necho "IIS_Auth_Bypass"\nuse auxiliary/admin/http/iis_auth_bypass\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nset ssl false\nrun\nsleep 5\nset rport 8080\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep5\nset rport 8443\nrun\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#IIS_ms15-034
printf '%s\necho "IIS_ms15_034"\nuse auxiliary/scanner/http/ms15_034_http_sys_memory_dump\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nset ssl false\ncheck\nsleep 5\nset rport 8080\ncheck\nsleep 5\nset ssl true\nset rport 443\ncheck\nsleep5\nset rport 8443\ncheck\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#IIS_Internal_IP
printf '%s\necho "IIS_Internal_IP"\nuse auxiliary/scanner/http/iis_internal_ip\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nset ssl false\nrun\nsleep 5\nset rport 8080\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep5\nset rport 8443\nrun\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#iis_tilde
printf '%s\nspool '$FOLDER'/output/ext_msf/iis_tilde.txt\necho "IIS_Tilde"\nuse auxiliary/scanner/http/iis_shortname_scanner\n' >> $FOLDER/output/ext_msf/resource.txt
awk '// {printf"\nset rhosts "$1"\nset vhost "$1"\nset rport 80\nrun\nsleep 5\nset ssl true\nset rport 443\nrun\nsleep 5\n"}' $HOSTS >> $FOLDER/output/ext_msf/resource.txt
#FTP
printf '%s\nspool '$FOLDER'/output/ext_msf/ftp.txt\necho "FTP"\nuse auxiliary/scanner/ftp/anonymous\nservices -u -p 21 -R\nrun\nsleep 5\n' >> $FOLDER/output/ext_msf/resource.txt
#VMWARE
printf '%s\nspool '$FOLDER'/output/ext_msf/vmware.txt\necho "VMWARE"\nuse exploit/linux/http/vmware_workspace_one_access_cve_2022_22954\nservices -u -p 443 -R\ncheck\nsleep 5\n' >> $FOLDER/output/ext_msf/resource.txt
#RPC portmap
printf '%s\nspool '$FOLDER'/output/ext_msf/rpc.txt\necho "RPC portmap"\nuse auxiliary/scanner/misc/sunrpc_portmapper\nservices -p 111 -u -R\nrun\nsleep 5\nservices -p 111 -u\n' >> $FOLDER/output/ext_msf/resource.txt
#rpc amp
printf '%s\necho "RPC amp"\nuse auxiliary/scanner/portmap/portmap_amp\nservices -p 111 -u -R\nrun\nsleep 5\n' >> $FOLDER/output/ext_msf/resource.txt
#MSF Resource File End
printf '%s\nspool off\nexit\n' >> $FOLDER/output/ext_msf/resource.txt

echo 'Start Metasploit'

msfdb init
msfconsole -qx "resource "$FOLDER"/output/ext_msf/workspace.txt "$FOLDER"/output/ext_msf/resource.txt"  > /dev/null 2>&1

echo 'Start nuclei'

#nuclei scanner
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
nuclei -update
nuclei -ut
nuclei -l $HOSTS -o $FOLDER/output/nuclei/nuclei.txt -headless -project $FOLDER/output/nuclei

echo 'looting'

### FTP
mkdir -p $FOLDER/output/loot/extern/ftp/anonymous
awk '/Anonymous READ/ {print$2}' $FOLDER/output/ext_msf/ftp.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/ftp/anonymous/hosts.txt
mkdir -p $FOLDER/output/loot/extern/ftp/unencrypted
awk '/FTP Banner/ {print$2}' $FOLDER/output/ext_msf/ftp.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/ftp/unencrypted/hosts.txt

### IIS
mkdir -p $FOLDER/output/loot/extern/web/iis_bypass
grep -B 1 'You can bypass auth' $FOLDER/output/ext_msf/web.txt | awk '/against/ {print$5}' | sort -u > $FOLDER/output/loot/extern/web/iis_bypass/hosts.txt
mkdir -p $FOLDER/output/loot/extern/web/ms15-034
awk '/The target is vulnerable/ {print$2}' $FOLDER/output/ext_msf/web.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/web/ms15-034/hosts.txt
mkdir -p $FOLDER/output/loot/extern/web/iis_tilde
awk '/The target is vulnerable/ {print$2}' $FOLDER/output/ext_msf/iis_tilde.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/web/iis_tilde/hosts.txt
mkdir -p $FOLDER/output/loot/extern/web/internal_ip
awk '/Found Internal IP/ {print}' $FOLDER/output/ext_msf/web.txt > $FOLDER/output/loot/extern/web/internal_ip/hosts.txt
mkdir -p $FOLDER/output/loot/extern/rpc/portmap
awk '/\+.*SunRPC/ {print$2}' $FOLDER/output/ext_msf/rpc.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/rpc/portmap/hosts.txt
mkdir -p $FOLDER/output/loot/extern/rpc/amplification
awk '/Vulnerable to Portmap/ {print$2}' $FOLDER/output/ext_msf/rpc.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/rpc/amplification/hosts.txt
### log4shell
mkdir -p $FOLDER/output/loot/extern/web/log4shell
awk '/Log4Shell found/{print$2}' $FOLDER/output/ext_msf/log4j.txt | cut -d ":" -f 1 | sort -u > $FOLDER/output/loot/extern/web/log4shell/hosts.txt

figlet AllDone!

exit 0
