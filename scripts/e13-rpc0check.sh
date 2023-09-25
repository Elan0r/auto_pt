#!/bin/bash

figlet RPC0Check

{
  echo "Start RPC0 check"
  date
} >>/root/output/runtime.txt

if command -v enum4linux-ng >/dev/null 2>&1; then
  e4l=enum4linux-ng
else
  e4l="python3 $(locate enum4linux-ng.py)"
fi

for i in $(cat /root/output/list/dc_ip.txt); do
  "$e4l" -A "$i" >>/root/output/loot/rpc/null_sessions/"$i".txt
done

{
  echo 'END RPC0 Check'
  date
} >>/root/output/runtime.txt
echo 'END RPC0 Check'
