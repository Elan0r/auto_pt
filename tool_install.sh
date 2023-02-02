#!/bin/bash
apt -qq install figlet -y > /dev/null
figlet ProSecBoxToolz
echo '! > '
echo '! > Tools go to /opt + ln -s to /root/tools'
echo '! > '
if  [ -h /root/tools ]; then
    echo '! > Tools Link ok'
else    
    if [ -d /root/tools ]; then
        mv /root/tools /root/tools_old
        ln -s /opt /root/tools
    else
        ln -s /opt /root/tools
    fi
fi

#CME Cleaning
rm -r /root/.cme

#APT
apt -qq update
apt -qq install tmux bettercap crackmapexec nbtscan responder metasploit-framework docker.io python3-pip libpcap-dev yersinia golang eyewitness enum4linux ipmitool -y

#SearchSploit
searchsploit -u

#PIP3
pip3 install --upgrade ldap3 Cython python-libpcap bloodhound pyx scapy mitm6 impacket minikerberos

#go env
if [ -d /opt/go ]; then
    echo '! > GO Folder Exist!'
else  
    mkdir /opt/go
fi

if grep -Fxq 'export PATH=$PATH:$GOPATH/bin' /root/.zshrc; then
      echo -e ''
else
      echo -e '\nexport GOPATH=/opt/go' >> /root/.zshrc
      echo -e '\nexport PATH=$PATH:$GOPATH/bin' >> /root/.zshrc
fi
export GOPATH=/opt/go
export PATH=$PATH:$GOPATH/bin

#GIT
cd /opt
#Petit Potam
if [ -d /opt/PetitPotam ]; then
    cd /opt/PetitPotam
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/topotam/PetitPotam.git
fi
#ESXi OpenSLP heap-overflow
if [ -d /opt/CVE-2021-21974 ]; then
    cd /opt/CVE-2021-21974
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/Shadow0ps/CVE-2021-21974.git
fi
#SIGRed RCE
if [ -d /opt/SIGRed_RCE_PoC ]; then
    cd /opt/SIGRed_RCE_PoC
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/chompie1337/SIGRed_RCE_PoC
fi
#PCredz
if [ -d /opt/PCredz ]; then
    cd /opt/PCredz
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/lgandx/PCredz.git
fi
#Enum4linux NG
if [ -d /opt/enum4linux-ng ]; then
    cd /opt/enum4linux-ng
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/cddmp/enum4linux-ng.git
fi
#Printer Exploitation Toolkit
if [ -d /opt/PRET ]; then
    cd /opt/PRET
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/RUB-NDS/PRET.git
fi
#Kerbrute
if [ -d /opt/kerbrute ]; then
    cd /opt/kerbrute
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/ropnop/kerbrute.git
fi
#NSE default Creds
if [ -d /opt/nndefaccts ]; then
    cd /opt/nndefaccts
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/nnposter/nndefaccts.git
fi
#UNICORN
if [ -d /opt/unicorn ]; then
    cd /opt/unicorn
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/trustedsec/unicorn.git
fi
#Pachine CVE-2021-42278 
if [ -d /opt/Pachine ]; then
    cd /opt/Pachine
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/ly4k/Pachine.git
fi
#noPAC CVE-2021-42278 and CVE-2021-42287
if [ -d /opt/noPac ]; then
    cd /opt/noPac
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/Ridter/noPac.git
fi
#certi.py
if [ -d /opt/certi ]; then
    cd /opt/certi
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/zer1t0/certi.git
fi
#PKINIT
if [ -d /opt/PKINITtools ]; then
    cd /opt/PKINITtools
    git stash
    git pull
    pip3 install --upgrade -r requirements.txt 
else
    cd /opt
    git clone https://github.com/dirkjanm/PKINITtools.git
    cd /opt/PKINITtools
    pip3 install --upgrade -r requirements.txt
fi
#LDAP Scan Tool
if [ -d /opt/LdapRelayScan ]; then
    cd /opt/LdapRelayScan
    git stash
    git pull
    pip3 install --upgrade -r requirements.txt 
else
    cd /opt
    git clone https://github.com/zyn3rgy/LdapRelayScan.git
    cd /opt/LdapRelayScan
    pip3 install --upgrade -r requirements.txt 
fi
#LDAP Domain Dump
if [ -d /opt/ldapdomaindump ]; then
    cd /opt/ldapdomaindump
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/dirkjanm/ldapdomaindump.git
fi
#webclientservicescanner
if [ -d /opt/WebclientServiceScanner ]; then
    cd /opt/WebclientServiceScanner
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/Hackndo/WebclientServiceScanner.git
    cd /opt/WebclientServiceScanner
    python3 ./setup.py install
fi
#krbrelayx
if [ -d /opt/krbrelayx ]; then
    cd /opt/krbrelayx
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/dirkjanm/krbrelayx.git
fi
#Certipy 2.0
if [ -d /opt/Certipy ]; then
    cd /opt/Certipy
    git stash
    git pull
    python3 setup.py install
else
    cd /opt
    git clone https://github.com/ly4k/Certipy.git
    cd /opt/Certipy
    python3 setup.py install
fi
#PassTheCert
if [ -d /opt/PassTheCert ]; then
    cd /opt/PassTheCert
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/AlmondOffSec/PassTheCert.git
fi

#Go
cd /opt
go install github.com/ropnop/kerbrute@latest
go install github.com/ropnop/go-windapsearch@latest
go install github.com/sensepost/gowitness@latest
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

#nuclei
nuclei -update
nuclei -update-templates

#docker
#Printnightmare Check
if [ -d /opt/ItWasAllADream ]; then
    cd /opt/ItWasAllADream
    git stash
    git pull
    docker build -t itwasalladream .
else
    cd /opt
    git clone https://github.com/byt3bl33d3r/ItWasAllADream.git
    cd /opt/ItWasAllADream
    docker build -t itwasalladream .
fi

#Special

#airgeddon
if [ -d /opt/airgeddon ]; then
    cd /opt/airgeddon
    git stash
    git pull
else
    cd /opt
    git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
    cd /opt/airgeddon
    bash airgeddon.sh
fi

#Nmap scripts
/opt/auto_pt/scripts/nse_install.sh

echo '! > '
echo '! > Tools go to /opt!'
echo '! > '
exit 0