#!/bin/bash
figlet ProSecToolz
echo '! > Tools go to /opt + ln -s to /root/tools'

ln -s /opt /root/tools

#APT
apt update
apt install crackmapexec responder metasploit-framework docker.io python3-pip libpcap-dev yersinia golang python3-venv -y
#PIP3!
pip3 install Cython python-libpcap bloodhound
pip3 install --upgrade ldap3

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
git clone https://gitlab-ci-token:ZGA2PFZZyut_zXevuPAR@gitlab.com/pspt/hacking.git
git clone https://github.com/topotam/PetitPotam.git
git clone https://github.com/dmaasland/proxyshell-poc.git
git clone https://github.com/Shadow0ps/CVE-2021-21974.git
git clone https://github.com/maxpl0it/CVE-2020-1350-DoS.git
git clone https://github.com/lgandx/PCredz.git
git clone https://github.com/EmpireProject/Empire.git
git clone https://github.com/cddmp/enum4linux-ng.git
git clone https://github.com/RUB-NDS/PRET.git
git clone https://github.com/ropnop/kerbrute.git

#Go
go get github.com/ropnop/kerbrute
go get github.com/ropnop/go-windapsearch
go get github.com/sensepost/gowitness

#special
git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
cd /opt/airgeddon && bash airgeddon.sh
cd /opt

git clone https://github.com/ExAndroidDev/impacket.git
cd impacket
git checkout ntlmrelayx-adcs-attack
python3 -m venv impacket
source impacket/bin/activate
pip install .
deactivate
cd /opt

#docker
docker pull empireproject/empire
git clone https://github.com/byt3bl33d3r/ItWasAllADream.git
cd /opt/ItWasAllADream && docker build -t itwasalladream .

exit 0
