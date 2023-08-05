#!/bin/bash

apt -qq install figlet -y >/dev/null

figlet ToolzInstall

echo '! > '
echo '! > Tools go to /opt'

install_tools() {
  #CME Cleaning
  rm -r /root/.cme

  #APT
  apt -qq update
  apt -qq install tmux bettercap nbtscan responder docker.io yersinia golang golang-go eyewitness enum4linux ipmitool chromium python3 python3-dev python3-pip python3-venv nmap smbmap john libpcap-dev libsasl2-dev libldap2-dev ntpdate wget zip unzip systemd-timesyncd pipx swig -y
 
  #SearchSploit
  #searchsploit -u

  #PIP3
  pip3 install --upgrade ldap3 Cython python-libpcap scapy mitm6 minikerberos

  #pipx
  pip3 install --user pipx PyYAML alive-progress xlsxwriter sectools --upgrade
  pipx ensurepath
  pipx install git+https://github.com/dirkjanm/ldapdomaindump.git --force
  pipx install git+https://github.com/mpgn/CrackMapExec.git --force
  pipx install git+https://github.com/ThePorgs/impacket.git --force
  pipx install git+https://github.com/zer1t0/certi.git --force
  pipx install git+https://github.com/ly4k/Certipy.git --force
  pipx install git+https://github.com/fox-it/BloodHound.py.git --force
  pipx install git+https://github.com/p0dalirius/Coercer --force

  #go env
  if [ -d /opt/go ]; then
    echo '! > GO Folder Exist!'
  else
    mkdir /opt/go
  fi

  if grep -Fxq 'export PATH=$PATH:$GOPATH/bin' /root/.zshrc; then
    echo -e ''
  else
    echo -e '\nexport GOPATH=/opt/go' >>/root/.zshrc
    echo -e '\nexport PATH=$PATH:$GOPATH/bin' >>/root/.zshrc
  fi
  export GOPATH=/opt/go
  export PATH=$PATH:$GOPATH/bin

  #GIT
  cd /opt || ! echo "Failure"
  #auto_pt
  if [ -d /opt/auto_pt ]; then
    cd /opt/auto_pt || ! echo "Failure"
    git stash
    git pull
  fi
  #Petit Potam
  if [ -d /opt/PetitPotam ]; then
    cd /opt/PetitPotam || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/topotam/PetitPotam.git
  fi
  #ESXi OpenSLP heap-overflow
  if [ -d /opt/CVE-2021-21974 ]; then
    cd /opt/CVE-2021-21974 || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/Shadow0ps/CVE-2021-21974.git
  fi
  #SIGRed RCE
  if [ -d /opt/SIGRed_RCE_PoC ]; then
    cd /opt/SIGRed_RCE_PoC || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/chompie1337/SIGRed_RCE_PoC
  fi
  #PCredz
  if [ -d /opt/PCredz ]; then
    cd /opt/PCredz || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/lgandx/PCredz.git
  fi
  #Enum4linux NG
  if [ -d /opt/enum4linux-ng ]; then
    cd /opt/enum4linux-ng || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/cddmp/enum4linux-ng.git
  fi
  #Printer Exploitation Toolkit
  if [ -d /opt/PRET ]; then
    cd /opt/PRET || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/RUB-NDS/PRET.git
  fi
  #Kerbrute
  if [ -d /opt/kerbrute ]; then
    cd /opt/kerbrute || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/ropnop/kerbrute.git
  fi
  #NSE default Creds
  if [ -d /opt/nndefaccts ]; then
    cd /opt/nndefaccts || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/nnposter/nndefaccts.git
  fi
  #UNICORN
  if [ -d /opt/unicorn ]; then
    cd /opt/unicorn || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/trustedsec/unicorn.git
  fi
  #Pachine CVE-2021-42278
  if [ -d /opt/Pachine ]; then
    cd /opt/Pachine || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/ly4k/Pachine.git
  fi
  #noPAC CVE-2021-42278 and CVE-2021-42287
  if [ -d /opt/noPac ]; then
    cd /opt/noPac || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/Ridter/noPac.git
  fi
  #PKINIT
  if [ -d /opt/PKINITtools ]; then
    cd /opt/PKINITtools || ! echo "Failure"
    git stash
    git pull
    pip3 install --upgrade -r requirements.txt
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/dirkjanm/PKINITtools.git
    cd /opt/PKINITtools || ! echo "Failure"
    pip3 install --upgrade -r requirements.txt
  fi
  #LDAP Scan Tool
  if [ -d /opt/LdapRelayScan ]; then
    cd /opt/LdapRelayScan || ! echo "Failure"
    git stash
    git pull
    pip3 install --upgrade -r requirements.txt
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/zyn3rgy/LdapRelayScan.git
    cd /opt/LdapRelayScan || ! echo "Failure"
    pip3 install --upgrade -r requirements.txt
  fi
  #webclientservicescanner
  if [ -d /opt/WebclientServiceScanner ]; then
    cd /opt/WebclientServiceScanner || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/Hackndo/WebclientServiceScanner.git
    cd /opt/WebclientServiceScanner || ! echo "Failure"
    python3 ./setup.py install
  fi
  #krbrelayx
  if [ -d /opt/krbrelayx ]; then
    cd /opt/krbrelayx || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/dirkjanm/krbrelayx.git
  fi
  #PassTheCert
  if [ -d /opt/PassTheCert ]; then
    cd /opt/PassTheCert || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/AlmondOffSec/PassTheCert.git
  fi
  #DFScoerce
  if [ -d /opt/DFSCoercet ]; then
    cd /opt/DFSCoerce || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/Wh04m1001/DFSCoerce.git
  fi
  #sploutchy impacket
  if [ -d /opt/impacket-sploutchy ]; then
    cd /opt/impacket-sploutchy || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/sploutchy/impacket /opt/impacket-sploutchy
  fi
  #CME Binary
  if [ -s /opt/cme_binary/cme ]; then
    echo "CME binary existend"
  else
    cd /opt || ! echo "Failure"
    curl --create-dirs -O --output-dir /opt/cme_binary https://github.com/mpgn/CrackMapExec/releases/download/v6.0.0/cme-ubuntu-latest-3.10.zip
    unzip /opt/cme_binary/cme-ubuntu-latest-3.10.zip -d /opt/cme_binary
    chmod +x /opt/cme_binary/cme
  fi

  #Go
  cd /opt || ! echo "Failure"
  go install github.com/ropnop/kerbrute
  go install github.com/sensepost/gowitness@latest
  go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

  #nuclei
  nuclei -update
  nuclei -update-templates

  #docker
  #Printnightmare Check
  if [ -d /opt/ItWasAllADream ]; then
    cd /opt/ItWasAllADream || ! echo "Failure"
    git stash
    git pull
    docker build -t itwasalladream .
  else
    cd /opt || ! echo "Failure"
    git clone https://github.com/byt3bl33d3r/ItWasAllADream.git
    cd /opt/ItWasAllADream || ! echo "Failure"
    docker build -t itwasalladream .
  fi

  #Special
  #gowindapsearch
  if [ -d /opt/windapsearch ]; then
    echo ''
  else
    mkdir /opt/windapsearch
  fi
  wget https://github.com/ropnop/go-windapsearch/releases/download/v0.3.0/windapsearch-linux-amd64 -O /opt/windapsearch/windapsearch
  chmod +x /opt/windapsearch/windapsearch
  ln -s /opt/windapsearch/windapsearch /usr/bin/

  #scrying
  if [ -d /opt/scrying ]; then
    echo ''
  else
    cd /opt || ! echo "Failure"
    wget https://github.com/nccgroup/scrying/releases/download/v0.9.2/scrying_0.9.2_amd64_linux.zip
    unzip scrying_0.9.2_amd64_linux.zip
    rm /opt/scrying_0.9.2_amd64_linux.zip
    cd /opt/scrying || ! echo "Failure"
    wget http://ftp.de.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1n-0+deb11u4_amd64.deb
    apt install /opt/scrying/libssl1.1_1.1.1n-0+deb11u4_amd64.deb
    wget https://github.com/nccgroup/scrying/releases/download/v0.9.2/scrying_0.9.2_amd64.deb
  #  apt install /opt/scrying/scrying_0.9.2_amd64.deb
  fi

  #airgeddon
  if [ -d /opt/airgeddon ]; then
    cd /opt/airgeddon || ! echo "Failure"
    git stash
    git pull
  else
    cd /opt || ! echo "Failure"
  git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
    cd /opt/airgeddon || ! echo "Failure"
    bash airgeddon.sh
  fi

  #Nmap scripts
  /opt/auto_pt/scripts/a11-nse_install.sh
}

install_tools || { echo -e "\n${RED}[Failure]${NC} Installing tools failed.. exiting script!\n"; exit 1; }

echo -e "\n${GREEN}[Success]${NC} Setup completed successfully!\n"
