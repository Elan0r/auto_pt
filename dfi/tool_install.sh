#!/bin/bash
apt -qq install figlet -y > /dev/null
figlet ProSecToolz
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

#APT
apt -qq update
apt -qq install bettercap crackmapexec nbtscan responder metasploit-framework docker.io python3-pip libpcap-dev yersinia golang texlive eyewitness enum4linux -y

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
#PSN Toolz
if [ -d /opt/hacking ]; then
    cd /opt/hacking
    git stash
    git pull
else
    cd /opt
    git clone https://gitlab-ci-token:ZGA2PFZZyut_zXevuPAR@gitlab.com/pspt/hacking.git
fi
#Petit Potam
if [ -d /opt/PetitPotam ]; then
    cd /opt/PetitPotam
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/topotam/PetitPotam.git
fi
#Proxyshell
if [ -d /opt/proxyshell-poc ]; then
    cd /opt/proxyshell-poc
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/dmaasland/proxyshell-poc.git
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
#SIGRed
if [ -d /opt/CVE-2020-1350-DoS ]; then
    cd /opt/CVE-2020-1350-DoS
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/maxpl0it/CVE-2020-1350-DoS.git
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
#Empire
if [ -d /opt/Empire ]; then
    cd /opt/Empire
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/EmpireProject/Empire.git
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
#Go
cd /opt
go install github.com/ropnop/kerbrute@latest
go install github.com/ropnop/go-windapsearch@latest
go install github.com/sensepost/gowitness@latest

#docker
#Empire Docker
cd /opt/Empire
    docker pull empireproject/empire
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
#impacket ADCS
if [ -d /opt/impacket ]; then
    rm -r /opt/impacket
    cd /opt
    git clone https://github.com/ExAndroidDev/impacket.git
    cd impacket
    git checkout ntlmrelayx-adcs-attack
    python3 setup.py install
else
    cd /opt
    git clone https://github.com/ExAndroidDev/impacket.git
    cd impacket
    git checkout ntlmrelayx-adcs-attack
    python3 setup.py install
fi
#PKINIT for PetitPotam
if [ -d /opt/PKINITtools ]; then
    cd /opt/PKINITtools
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/dirkjanm/PKINITtools.git
    cd /opt/PKINITtools
    pip3 install --upgrade -r requirements.txt
fi
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
/opt/hacking/nmap_scripts/nse_install.sh
echo '! > '
echo '! > Tools go to /opt!'
echo '! > '
exit 0
