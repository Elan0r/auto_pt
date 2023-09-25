#!/bin/bash

figlet SMBrecon

#Anonymous Shares
echo 'CME Anonymous Shares'
echo 'CME is buggy need to Press ENTER after a while!'
{
  echo 'CME Anonymous Shares'
  date
} >>/root/output/runtime.txt

crackmapexec smb /root/output/list/smb_open.txt -u '' -p '' --shares --log /root/output/loot/smb/anonymous_enumeration/cme_raw_shares.txt >/dev/null 2>&1
grep -a 'READ' /root/output/loot/smb/anonymous_enumeration/cme_raw_shares.txt | grep -v 'IPC\$\|print\$' >/root/output/loot/smb/anonymous_enumeration/cme_shares.txt

if [ ! -s /root/output/list/smb_sign_off.txt ]; then
  echo 'CME SMB no Signing'
  echo 'CME is buggy need to Press ENTER after a while!'
  {
    echo 'CME SMB no Signing'
    date
  } >>/root/output/runtime.txt

  crackmapexec smb /root/output/list/smb_open.txt --gen-relay-list /root/output/list/smb_sign_off.txt >/root/output/cme_beauty.txt 2>&1
fi

for i in $(cat /root/output/list/smb_sign_off.txt); do
  echo smb://"$i" >>/root/output/list/relay_smb.txt
done

{
  echo 'END CME SMB Recon'
  date
} >>/root/output/runtime.txt
echo 'END CME SMB Recon'
