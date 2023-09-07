#!/bin/bash

figlet MSFWorkspace

if [ -s /root/input/msf/workspace.txt ]; then
  echo 'Workspace already set!'
else
  read -r -p "Enter Workspace Name: " WS
  echo 'workspace -d ' "$WS" >/root/input/msf/workspace.txt
  echo 'workspace -a ' "$WS" >>/root/input/msf/workspace.txt
  echo 'db_import /root/output/nmap/service.xml' >>/root/input/msf/workspace.txt
  #for Zerocheck
  echo 'workspace -a ' "$WS" >/root/input/msf/ws.txt

  figlet "Mail Address for relay"
  read -r -p "enter internal e-mail: " INMAIL
  if [[ $INMAIL =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Valid email format"
  else
    echo "Invalid email format"
    exit 1
  fi
  sed -i "s/INTERN@EXAMPLE.COM/$INMAIL/g" /opt/auto_pt/resources/resource.txt

  read -r -p "enter external e-mail: " EXMAIL
  if [[ $EXMAIL =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Valid email format"
  else
    echo "Invalid email format"
    exit 1
  fi
  sed -i "s/EXTERN@EXAMPLE.COM/$EXMAIL/g" /opt/auto_pt/resources/resource.txt

fi

figlet 'Workspace Set'
