#!/bin/bash
figlet ProSecToolz
echo '! > Tools go to /opt + ln -s to /root/tools'

#APT
apt install docker.io python3-pip libpcap-dev yersinia -y
#PIP3!
pip3 install Cython python-libpcap bloodhound

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

#special
git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
cd /opt/airgeddon && bash airgeddon.sh
cd /opt
ln -s /opt /root/tools

#docker
docker pull empireproject/empire
git clone https://github.com/byt3bl33d3r/ItWasAllADream.git
cd /opt/ItWasAllADream && docker build -t itwasalladream .
exit 0
