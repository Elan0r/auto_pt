#!/bin/bash

figlet ProSecSSLscan

#sslscan 4 weak cipher
if [ -s /root/output/msf/sslscan.txt ]; then
  echo '! >> SSL Scan already Done.'
else
  echo '! > Weak Ciphers Background Job start!'
  sslscan --targets=/root/output/list/ssl_open.txt >/root/output/msf/sslscan.txt 2>&1 &
fi

echo 'END SSL Check' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
