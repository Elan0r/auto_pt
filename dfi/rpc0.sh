#!/bin/bash

figlet ProSecRPC0

echo "Start RPC0 check" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

for i in $(cat /root/output/list/dc_ip.txt)
do
python3 /opt/enum4linux-ng/enum4linux-ng.py -A $i > /root/output/loot/intern/rpc/null_sessions/$i.txt
done
