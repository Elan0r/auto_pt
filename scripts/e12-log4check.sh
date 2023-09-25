#!/bin/bash

figlet Log4ShellCheck

if [ ! -s /opt/auto_pt/resources/log4j.txt ]; then
  echo '! > log4j.txt resource missing here: /opt/auto_pt/resources/ !'
  exit 1
fi

if [ ! -s /root/input/msf/ws.txt ]; then
  echo '! > ws.txt missing here: /root/input/msf/'
  echo '! > use the menu option O'
  exit 1
fi

{
  echo "Start MSF Log4Shell check"
  date
} >>/root/output/runtime.txt

msfconsole -qx "resource /root/input/msf/ws.txt /opt/auto_pt/resources/log4j.txt" >/dev/null

{
  echo 'END Log4Shell Check'
  date
} >>/root/output/runtime.txt
echo 'END Log4Shell Check'
