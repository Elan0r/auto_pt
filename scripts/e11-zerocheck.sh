#!/bin/bash

figlet ZeroCheck

#MSF Resource File
{
  printf 'spool /root/output/msf/zerologon.txt\necho "ZeroLogon"\nuse auxiliary/admin/dcerpc/cve_2020_1472_zerologon\n'
  paste /root/output/list/dc_ip.txt /root/output/list/dc_nbt.txt | awk '// {printf"\nset nbname "$2"\nset rhosts "$1"\ncheck\nsleep 5\n"}'
  printf '\nexit\n'
} >/root/input/msf/zerocheck.txt

if [ ! -s /root/input/msf/ws.txt ]; then
  echo '! > ws.txt missing here: /root/input/msf/'
  echo '! > use the menu option O'
  exit 1
fi

{
  echo "Start MSF Zerologon check"
  date
} >>/root/output/runtime.txt

msfconsole -qx "resource /root/input/msf/ws.txt /root/input/msf/zerocheck.txt" >/dev/null

{
  echo 'END Zerologon check'
  date
} >>/root/output/runtime.txt
echo 'END Zerologon check'
