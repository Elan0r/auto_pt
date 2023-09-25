#!/bin/bash
# shellcheck disable=SC2034
#Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
INVB='\e[44;1m'
RE='\033[0m\e[44;1m'
NC='\033[0m'

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

# create nessesary folder
/opt/auto_pt/scripts/b10-folder.sh

#rename Window
tmux rename-window '**Auto PT**'

# shellcheck disable=SC1091
while true; do
  echo -e "${CYAN}-----------------------------------------------------------${RED}"
  figlet "**Auto PT**"
  echo -e "${GREEN}by @Elan0r"
  echo -e "${CYAN}|---------------------------------------------------------|"
  echo -e "| All Scripts are tracked in ${RED}runtime.txt${CYAN} in output        |"
  echo -e "| Details of all Scripts in SubMenu                       |"
  echo -e "| ${YELLOW}Select an option from the list:${CYAN}                         |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Preparation${CYAN}                                             |"
  echo -e "| ${PURPLE}A${CYAN} Tool Installer                                        |"
  echo -e "| ${PURPLE}B${CYAN} Folder Re-Creation                                    |"
  echo -e "| ${PURPLE}C${CYAN} Passiv Listener                                       |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Testing${CYAN}                                                 |"
  echo -e "| ${PURPLE}D${CYAN} Host and Service Discovery                            |"
  echo -e "| ${PURPLE}E${CYAN} Vulnerability Analysis (MSF+X)                        |"
  echo -e "| ${PURPLE}F${CYAN} 5 min Responder Relay                                 |"
  echo -e "| ${PURPLE}G${CYAN} Collect loot an RAW files                             |"
  echo -e "| ${PURPLE}H${CYAN} Create host.txts and findings.txt                     |"
  echo -e "| ${PURPLE}I${CYAN} Eyewitness scan all webservices                       |"
  echo -e "| ${PURPLE}J${CYAN} Collect default splash pages                          |"
  echo -e "| ${PURPLE}K${CYAN} Run all above exept installer and passiv              |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}L${CYAN} OT systems scan                                       |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}N${CYAN} Userchecks ${RED}(Creds required!)${CYAN}                          |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Alligning${CYAN}                                               |"
  echo -e "| ${PURPLE}O${CYAN} Set Workspace                                         |"
  echo -e "| ${PURPLE}P${CYAN} Change interface (default eth0)                       |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}External${CYAN}                                                |"
  echo -e "| ${PURPLE}R${CYAN} Security Header                                       |"
  echo -e "| ${PURPLE}S${CYAN} the Harvester                                         |"
  echo -e "| ${PURPLE}T${CYAN} Slow HTTP Test                                        |"
  echo -e "| ${PURPLE}U${CYAN} Mail Checks                                           |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}X${RED} Cleanup the mess${CYAN}                                      |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}Z${CYAN} Show status                                           |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}0${RED} Exit${CYAN}                                                  |"
  echo -e "-----------------------------------------------------------${NC}"
  read -r abcdefghijklnoprstuxz0
  case $abcdefghijklnoprstuxz0 in
    [aA])
      echo -e "${INVB}            Tool Installer                                 ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Ths script will install common used tools      ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start installation? ${GREEN}y${RE}/${RED}n${RE}                        ${NC}"
      echo -e ""
      while true; do
        read -r y
        case $y in
          [yY])
            source /opt/auto_pt/scripts/a10-tool_install.sh
            break
            ;;

          *)
            echo -e "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [bB])
      echo -e "${INVB}            Folder Creation                                ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Ths script will create folders if not present  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start creation? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo -e ""
      while true; do
        read -r y
        case $y in
          [yY])
            source /opt/auto_pt/scripts/b10-folder.sh
            break
            ;;

          *)
            echo -e "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [cC])
      echo -e "${INVB}            Passive Listener                               ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Ths script will start passive Recon            ${NC}"
      echo -e "${INVB}            Netdiscover for quick host and network view    ${NC}"
      echo -e "${INVB}            PCredz for hash collection                     ${NC}"
      echo -e "${INVB}            tcpdump for further traffic analysis           ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start listener? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/c10-passive_recon.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [dD])
      echo -e "${INVB}            Active Recon                                   ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            This script will scann all networks            ${NC}"
      echo -e "${INVB}            can create Scope for check with customer       ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            DNSenum with nmap sL scan all private IPs      ${NC}"
      echo -e "${INVB}            nmap PE and sO for Host Discovery              ${NC}"
      echo -e "${INVB}            nmap sSV for Service detection                 ${NC}"
      echo -e "${INVB}            CME anonymous Shares detection                 ${NC}"
      echo -e "${INVB}            CME SMB no Signing detection                   ${NC}"
      echo -e "${INVB}            DNSrecon and DNS Zone Transfer                 ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Creates Info Gathering summary in output       ${NC}"
      echo -e "${INVB}            S and P includes the Report by default         ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Scope Present or not?                          ${NC}"
      echo -e "${INVB}            If not use DNSenum for Scope definition        ${NC}"
      echo -e "${INVB}            DNSEnum (${YELLOW}d${RE}) or ActiveRecon (${YELLOW}p${RE})                 ${NC}"
      echo -e "${INVB}            DNSenum and ActiveRecon (${YELLOW}s${RE})                    ${NC}"
      echo -e "${INVB}            Report only (${YELLOW}r${RE})                                ${NC}"
      echo -e "${INVB}            Back to Main Menu (${RED}x${RE})                          ${NC}"
      while true; do
        read -r dprsx
        case $dprsx in
          [dD])
            source /opt/auto_pt/scripts/d10-dns_scan.sh
            break
            ;;

          [pP])
            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/d12-list.sh
            source /opt/auto_pt/scripts/d13-smbrecon.sh
            source /opt/auto_pt/scripts/d14-dnsrecon.sh
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [sS])
            source /opt/auto_pt/scripts/d10-dns_scan.sh
            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/d12-list.sh
            source /opt/auto_pt/scripts/d13-smbrecon.sh
            source /opt/auto_pt/scripts/d14-dnsrecon.sh
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [rR])
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [xX])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}D, P, R, S or X${NC}"
            ;;
        esac
      done
      continue
      ;;

    [eE])
      echo -e "${INVB}            Vulnerability Analysis (MSF+X)                 ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Ths script will start VA                       ${NC}"
      echo -e "${INVB}            Pre-set the MSF workspace with the O menu      ${NC}"
      echo -e "${INVB}            Metasploit for general exploitability          ${NC}"
      echo -e "${INVB}            MSF ZeroLogon                                  ${NC}"
      echo -e "${INVB}            RPC 0 Session with enum4linux-ng               ${NC}"
      echo -e "${INVB}            default Creds with nmap and nndefaccts         ${NC}"
      echo -e "${INVB}            SSL Scan with heartbleet                       ${NC}"
      echo -e "${INVB}            NO list creation! Active recon recommended!    ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Workspace set?                                 ${NC}"
      echo -e "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/e10-autosploit.sh
            source /opt/auto_pt/scripts/e11-zerocheck.sh
            source /opt/auto_pt/scripts/e12-log4check.sh
            source /opt/auto_pt/scripts/e13-rpc0check.sh
            source /opt/auto_pt/scripts/e14-def_creds.sh
            source /opt/auto_pt/scripts/e15-service_enum.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [fF])
      echo -e "${INVB}            Responder Relay                                ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            This Script starts Responder -wbFP on eth0     ${NC}"
      echo -e "${INVB}            Ntlmrelyx versus smb_no_signing.txt            ${NC}"
      echo -e "${INVB}            If missing it will create a list               ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start relay? ${GREEN}y${RE}/${RED}n${RE}                               ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [gG])
      echo -e "${INVB}            Looting                                        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Collects all loot from previous scripts        ${NC}"
      echo -e "${INVB}            Creates hosts.txt for each finding             ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start looting? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/g10-looter.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [hH])
      echo -e "${INVB}            Counting Loot                                  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Counts all loot                                ${NC}"
      echo -e "${INVB}            Creates findings.txt in output                 ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start counting? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/h10-counter.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [iI])
      echo -e "${INVB}            Eyewitness                                     ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Makes screens of all websites                  ${NC}"
      echo -e "${INVB}            uses nmap ${RED}service.xml${RE} from active recon        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start photosession? ${GREEN}y${RE}/${RED}n${RE}                        ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [jJ])
      echo -e "${INVB}            Splash Screen looter                           ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Collect all Splashscreens from eyewitness      ${NC}"
      echo -e "${INVB}            Creates hosts.txt for each finding             ${NC}"
      echo -e "${INVB}            attaches result in findings.txt in output      ${NC}"
      echo -e "${INVB}            Eyewitness needs to finish for usable results  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start looting? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [kK])
      echo -e "${INVB}            Auto_PT                                        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            All AutoPT scripts                             ${NC}"
      echo -e "${INVB}            Pre-set the MSF workspace with the O menu      ${NC}"
      echo -e "${INVB}            Main Menu D till J                             ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Workspace set?                                 ${NC}"
      echo -e "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            echo -e "${INVB}            Scope Present or not?                          ${NC}"
            echo -e "${INVB}            If not use DNSenum for Scope definition        ${NC}"
            echo -e "${INVB}            DNSEnum (d) or scope present (p)               ${NC}"
            while true; do
              read -r dp
              case $dp in
                [dD])
                  source /opt/auto_pt/scripts/d10-dns_scan.sh
                  break
                  ;;

                [pP])
                  break
                  ;;
              esac
            done

            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/d12-list.sh
            source /opt/auto_pt/scripts/d13-smbrecon.sh
            source /opt/auto_pt/scripts/d14-dnsrecon.sh
            source /opt/auto_pt/scripts/d99-report.sh
            source /opt/auto_pt/scripts/e10-autosploit.sh
            source /opt/auto_pt/scripts/e11-zerocheck.sh
            source /opt/auto_pt/scripts/e12-log4check.sh
            source /opt/auto_pt/scripts/e13-rpc0check.sh
            source /opt/auto_pt/scripts/e14-def_creds.sh
            source /opt/auto_pt/scripts/e15-service_enum.sh
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            source /opt/auto_pt/scripts/g10-looter.sh
            source /opt/auto_pt/scripts/h10-counter.sh
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [lL])
      echo -e "${INVB}            OT Scan                                        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Scans OT related stuff                         ${NC}"
      echo -e "${INVB}            this really will take some time                ${NC}"
      echo -e "${INVB}            OT is slow!                                    ${NC}"
      echo -e "${INVB}            Eyewitness needs to finish for usable results  ${NC}"
      echo -e "${INVB}            needs ipot.txt in input                        ${NC}"
      echo -e "${INVB}            is   ${RED}ipot.txt${RE}  present?                        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            start OT scan? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/l10-otscan.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [nN])
      echo -e "${INVB}            User Checks                                    ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Collection of Checks!                          ${NC}"
      echo -e "${INVB}            Will be LOUD!                                  ${NC}"
      echo -e "${INVB}            DNS Zone Transfer                              ${NC}"
      echo -e "${INVB}            Username as Password with CME                  ${NC}"
      echo -e "${INVB}            Creates BH import query for valid accounts     ${NC}"
      echo -e "${INVB}            GPP Autologin with CME                         ${NC}"
      echo -e "${INVB}            GPP Password with CME                          ${NC}"
      echo -e "${INVB}            Looting of GPP Checks in host.txt              ${NC}"
      echo -e "${INVB}            Check Pass-Pol with CME                        ${NC}"
      echo -e "${INVB}            Check nopac with CME                           ${NC}"
      echo -e "${INVB}            Check petitpotam with CME                      ${NC}"
      echo -e "${INVB}            Check DFScoerce with CME                       ${NC}"
      echo -e "${INVB}            Check Shacowcoerce with CME                    ${NC}"
      echo -e "${INVB}            Check ntlmv1 with CME                          ${NC}"
      echo -e "${INVB}            Check SMB sessions with CME                    ${NC}"
      echo -e "${INVB}            Check ASRep with CME                           ${NC}"
      echo -e "${INVB}            Check Kerberoasting with CME                   ${NC}"
      echo -e "${INVB}            Check MAQ with CME                             ${NC}"
      echo -e "${INVB}            Check ldap signing with CME and ldaprelaycheck ${NC}"
      echo -e "${INVB}            Makes Bloodhound dump                          ${NC}"
      echo -e "${INVB}            Makes Certipy dump for old-bloodhound          ${NC}"
      echo -e "${INVB}            CME LDAP Checks may be broken                  ${NC}"
      echo -e "${INVB}            CME may be broken u need to press ENTER often! ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/n10-user_checks.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [oO])
      echo -e "${INVB}            MSF Workspace                                  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Set new MSF workspace for the Modules          ${NC}"
      echo -e "${INVB}            Set E-Mail for SMTP Checks in resource.txt     ${NC}"
      echo -e "${INVB}            creates files in input/msf                     ${NC}"
      echo -e "${INVB}            will NOT delete existing workspace!            ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            New Workspace? ${GREEN}y${RE}/${RED}n${RE}?                            ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            rm /root/input/msf/w*
            source /opt/auto_pt/scripts/o10-workspace.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [pP])
      echo -e "${INVB}            Select Interface                               ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Set new Interface                              ${NC}"
      echo -e "${INVB}            Changes all Scripts in auto_pt                 ${NC}"
      echo -e "${INVB}            Default is ${YELLOW}eth0${RE}                                ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            New Interface? ${GREEN}y${RE}/${RED}n${RE}?                            ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/p10-interface.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [rR])
      echo -e "${INVB}            Security Header Check                          ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Checks Webserver                               ${NC}"
      echo -e "${INVB}            with shcheck.py                                ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start Check? ${GREEN}y${RE}/${RED}n${RE}?                              ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/r10-sheader.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [sS])
      echo -e "${INVB}            the Harvester                                  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Harvest Stuff                                  ${NC}"
      echo -e "${INVB}            dont forget to set yout API Keys               ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start harvesting? ${GREEN}y${RE}/${RED}n${RE}?                         ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/s10-harvester.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [tT])
      echo -e "${INVB}            Slow http Check DoS                            ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            ${YELLOW}Attention ! ${INVB}                                   ${NC}"
      echo -e "${INVB}            ${YELLOW}this is a Denial of Service${INVB}                    ${NC}"
      echo -e "${INVB}            DoS to Webserver                               ${NC}"
      echo -e "${INVB}            with slowhttptest                              ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start DoS? ${GREEN}y${RE}/${RED}n${RE}?                                ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/t10-slowhttp.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [uU])
      echo -e "${INVB}            MailTester                                     ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Checks Mailserver                              ${NC}"
      echo -e "${INVB}            and some more                                  ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Start Check? ${GREEN}y${RE}/${RED}n${RE}?                              ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/u10-mailtest.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [xX])
      echo -e "${INVB}            Heiko Schotte, Firma Lausen                    ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Heiko is a Tatortreiniger.                     ${NC}"
      echo -e "${INVB}            He will clean up your mess!                    ${NC}"
      echo -e "${INVB}            This will barely leave a proof on this system! ${NC}"
      echo -e "${INVB}            All will be lost!                              ${NC}"
      echo -e "${INVB}            No Backup, no Sorry!                           ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/x10-cleaner.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [zZ])
      echo -e "${INVB}            Runtime                                        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            Opens runtime.txt in split-pane                ${NC}"
      echo -e "${INVB}            is following runtime.txt (auto refresh)        ${NC}"
      echo -e "${INVB}-----------------------------------------------------------${NC}"
      echo -e "${INVB}            view status? ${GREEN}y${RE}/${RED}n${RE}?                              ${NC}"
      echo -e ""
      while true; do
        read -r yn
        case $yn in
          [yY])
            source /opt/auto_pt/scripts/z10-status.sh
            break
            ;;

          [nN])
            echo -e "${RED}go back${NC}"
            break
            ;;

          *)
            echo -e "${YELLOW}Please answer ${GREEN}Y ${NC}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [0])
      break
      ;;

    *)
      echo -e "\n${INVB}            ${YELLOW}Select a valid option from the list!           ${NC}\n"
      ;;
  esac
done

echo -e "${BLUE}"
figlet 'All Done'
echo -e "${NC}"

exit 0
