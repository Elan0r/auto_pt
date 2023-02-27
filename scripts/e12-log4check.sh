#!/bin/bash

figlet -w 104 ProSecLog4ShellCheck

echo '! > Log4J check via ETH0!'

if [ -s /opt/auto_pt/resources/log4j.txt ]; then
  echo '! > Log4J resource OK!'
else
  echo '! > log4j.txt resource missing here: /opt/auto_pt/resources/ !'
  exit 1
fi

echo "Start MSF Log4Shell check" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

msfconsole -qx "resource /root/input/msf/ws.txt /opt/auto_pt/resources/log4j.txt" >/dev/null
echo '! > Log4Shell Check Done!'

echo 'END Log4Shell Check' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
