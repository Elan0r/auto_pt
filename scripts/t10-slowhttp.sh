#!/bin/bash

figlet SlowHTTP

read -e -r -p 'File with Domains for SlowHTTP (no http/https): ' HOSTS
if [ -z "$HOSTS" ]; then
  echo -e '! >set File!'
  exit 1
else
  if [ ! -s "$HOSTS" ]; then
    echo "! >>NO File"
    exit 1
  fi
fi

read -r -p 'Test TIME in SECONDS (default 10) : ' TIME
if [ -z "$TIME" ]; then
  TIME=10
  echo -e '! >TIME = ' "$TIME"
else
  echo -e '! >TIME = ' "$TIME"
fi

{
  echo "Start slowHTTP"
  date
} >>/root/output/runtime.txt
for i in $(cat "$HOSTS"); do
  slowhttptest -l "$TIME" -g -o /root/output/loot/web/slowhttp/raw/"$i" -u https://"$i" -c 9999 -r 2000 -b 240
  sleep 5
done

{
  echo "END SlowHTTP"
  date
} >>/root/output/runtime.txt
echo "END SlowHTTP"
