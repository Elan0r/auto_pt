#!/bin/bash

figlet MSFWorkspace

read -r -p "Enter Workspace Name: " WS
{
  echo "workspace -a $WS"
  echo "db_import /root/output/nmap/service.xml"
} >/root/input/msf/workspace.txt
#for Zerocheck
echo "workspace -a $WS" >/root/input/msf/ws.txt

echo "Mail Address for Mail-relay"
read -r -p "enter internal e-mail: " INMAIL
if [[ $INMAIL =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Valid email format"
else
  echo "Invalid email format"
  exit 1
fi
#for script reuse
sed -i "s/INTERN@EXAMPLE.COM/$INMAIL/g" /opt/auto_pt/resources/resource.txt /opt/auto_pt/scripts/o10-workspace.sh

read -r -p "enter external e-mail: " EXMAIL
if [[ $EXMAIL =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Valid email format"
else
  echo "Invalid email format"
  exit 1
fi
#for script reuse
sed -i "s/EXTERN@EXAMPLE.COM/$EXMAIL/g" /opt/auto_pt/resources/resource.txt /opt/auto_pt/scripts/o10-workspace.sh

figlet 'Workspace Set'
