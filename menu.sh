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

# create nessesary folder
/opt/auto_pt/scripts/b10-folder.sh

#rename Window
tmux rename-window '**Auto PT**'

# shellcheck disable=SC1091
while true; do
  echo "${CYAN}-----------------------------------------------------------${RED}"
  figlet "**Auto PT**"
  echo "${GREEN}by @Elan0r"
  echo "${CYAN}|---------------------------------------------------------|"
  echo "| All Scripts are tracked in ${RED}runtime.txt${CYAN} in output        |"
  echo "| Details of all Scripts in SubMenu                       |"
  echo "| ${YELLOW}Select an option from the list:                         ${CYAN}|"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}A${CYAN} Tool Installer                                        |"
  echo "| ${PURPLE}B${CYAN} Folder Re-Creation                                    |"
  echo "| ${PURPLE}C${CYAN} Passiv Listener                                       |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}D${CYAN} Host and Service Discovery                            |"
  echo "| ${PURPLE}E${CYAN} Vulnerability Analysis (MSF+X)                        |"
  echo "| ${PURPLE}F${CYAN} 5 min Responder Relay                                 |"
  echo "| ${PURPLE}G${CYAN} Collect loot an RAW files                             |"
  echo "| ${PURPLE}H${CYAN} Create Host.txt and Findings.txt                      |"
  echo "| ${PURPLE}I${CYAN} Eyewitness scan all webservices                       |"
  echo "| ${PURPLE}J${CYAN} Collect default splash pages                          |"
  echo "| ${PURPLE}K${CYAN} Run all above exept installer and passiv              |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}L${CYAN} OT systems scan                                       |"
  echo "| ${PURPLE}M${CYAN} Cleanup the mess                                      |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}N${CYAN} Userchecks ${RED}(Creds required\!)${CYAN}                          |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}O${CYAN} Set Workspace                                         |"
  echo "| ${PURPLE}P${CYAN} Change interface (default eth0)                       |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}Z${CYAN} Show status                                           |"
  echo "|---------------------------------------------------------|"
  echo "| ${PURPLE}0${RED} Exit${CYAN}                                                  |"
  echo "-----------------------------------------------------------${NC}"
  read -r abcdefghijklmnopz0
  case $abcdefghijklmnopz0 in
    [aA])
      echo "${INVB}            Tool Installer                                 ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Ths script will install common used tools      ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start installation? ${GREEN}y${RE}/${RED}n${RE}                        ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/a10-tool_install.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [bB])
      echo "${INVB}            Folder Creation                                ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Ths script will create folders if not present  ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start creation? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/b10-folder.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [cC])
      echo "${INVB}            Passive Listener                               ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Ths script will start passive Recon            ${NC}"
      echo "${INVB}            Netdiscover for quick host and network view    ${NC}"
      echo "${INVB}            PCredz for hash collection                     ${NC}"
      echo "${INVB}            tcpdump for further traffic analysis           ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start listener? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/c10-passive_recon.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [dD])
      echo "${INVB}            Active Recon                                   ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            This script will scann all networks            ${NC}"
      echo "${INVB}            can create Scope for check with customer       ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            DNSenum with nmap sL scan all private IPs      ${NC}"
      echo "${INVB}            nmap PE and sO for Host Discovery              ${NC}"
      echo "${INVB}            nmap sSV for Service detection                 ${NC}"
      echo "${INVB}            CME anonymous Shares detection                 ${NC}"
      echo "${INVB}            CME SMB no Signing detection                   ${NC}"
      echo "${INVB}            DNSrecon and DNS Zone Transfer                 ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Creates Info Gathering summary in output       ${NC}"
      echo "${INVB}            S and P includes the Report by default         ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Scope Present or not?                          ${NC}"
      echo "${INVB}            If not use DNSenum for Scope definition        ${NC}"
      echo "${INVB}            DNSEnum (${YELLOW}d${RE}) or ActiveRecon (${YELLOW}p${RE})                 ${NC}"
      echo "${INVB}            DNSenum and ActiveRecon (${YELLOW}s${RE})                    ${NC}"
      echo "${INVB}            Report only (${YELLOW}r${RE})                                ${NC}"
      echo "${INVB}            Back to Main Menu (${RED}x${RE})                          ${NC}"
      while true; do
        read -r dprsx
        case $dprsx in
          [dD]*)
            source /opt/auto_pt/scripts/d10_dns_scan.sh
            break
            ;;

          [pP]*)
            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/d12-list.sh
            source /opt/auto_pt/scripts/d13-smbrecon.sh
            source /opt/auto_pt/scripts/d14-dnsrecon.sh
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [sS]*)
            source /opt/auto_pt/scripts/d10_dns_scan.sh
            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/d12-list.sh
            source /opt/auto_pt/scripts/d13-smbrecon.sh
            source /opt/auto_pt/scripts/d14-dnsrecon.sh
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [rR]*)
            source /opt/auto_pt/scripts/d99-report.sh
            break
            ;;

          [xX]*)
            echo "${RED}go back${NC}"
            break
            ;;

          *)
            echo "${YELLOW}Please answer ${GREEN}D, P, R, S or X${NC}"
            ;;
        esac
      done
      continue
      ;;

    [eE])
      echo "${INVB}            Vulnerability Analysis (MSF+X)                 ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Ths script will start VA                       ${NC}"
      echo "${INVB}            Metasploit for general exploitability          ${NC}"
      echo "${INVB}            MSF ZeroLogon                                  ${NC}"
      echo "${INVB}            RPC 0 Session with enum4linux-ng               ${NC}"
      echo "${INVB}            default Creds with nmap and nndefaccts         ${NC}"
      echo "${INVB}            SSL Scan with heartbleet                       ${NC}"
      echo "${INVB}            NO list creation! Active recon recommended!    ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start VA? ${GREEN}y${RE}/${RED}n${RE}                                  ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/o10-workspace.sh
            source /opt/auto_pt/scripts/e10-autosploit.sh
            source /opt/auto_pt/scripts/e11-zerocheck.sh
            source /opt/auto_pt/scripts/e12-log4check.sh
            source /opt/auto_pt/scripts/e13-rpc0check.sh
            source /opt/auto_pt/scripts/e14-def_creds.sh
            source /opt/auto_pt/scripts/e15-service_enum.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [fF])
      echo "${INVB}            Responder Relay                                ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            This Script starts Responder -wbFP on eth0     ${NC}"
      echo "${INVB}            Ntlmrelyx versus smb_no_signing.txt            ${NC}"
      echo "${INVB}            If missing it will create a list               ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start relay? ${GREEN}y${RE}/${RED}n${RE}                               ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [gG])
      echo "${INVB}            Looting                                        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Collects all loot from previous scripts        ${NC}"
      echo "${INVB}            Creates hosts.txt for each finding             ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start looting? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/g10-looter.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [hH])
      echo "${INVB}            Counting Loot                                  ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Counts all loot                                ${NC}"
      echo "${INVB}            Creates findings.txt in output                 ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start counting? ${GREEN}y${RE}/${RED}n${RE}                            ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/h10-counter.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [iI])
      echo "${INVB}            Eyewitness                                     ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Makes screens of all websites                  ${NC}"
      echo "${INVB}            uses nmap ${RED}service.xml${RE} from active recon        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start photosession? ${GREEN}y${RE}/${RED}n${RE}                        ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [jJ])
      echo "${INVB}            Splash Screen looter                           ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Collect all Splashscreens from eyewitness      ${NC}"
      echo "${INVB}            Creates hosts.txt for each finding             ${NC}"
      echo "${INVB}            attaches result in findings.txt in output      ${NC}"
      echo "${INVB}            Eyewitness needs to finish for usable results  ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Start looting? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [kK])
      echo "${INVB}            Auto_PT                                        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            All AutoPT scripts                             ${NC}"
      echo "${INVB}            Pre-set the MSF workspace with the O menu      ${NC}"
      echo "${INVB}            Main Menu D till J                             ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Workspace set?                                 ${NC}"
      echo "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            echo "${INVB}            Scope Present or not?                          ${NC}"
            echo "${INVB}            If not use DNSenum for Scope definition        ${NC}"
            echo "${INVB}            DNSEnum (d) or scope present (p)               ${NC}"
            while true; do
              read -r dp
              case $dp in
                [dD]*)
                  source /opt/auto_pt/scripts/d10_dns_scan.sh
                  break
                  ;;

                [pP]*)
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
            source /opt/auto_pt/scripts/e16-relaylists.sh
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            source /opt/auto_pt/scripts/g10-looter.sh
            source /opt/auto_pt/scripts/h10-counter.sh
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [lL])
      echo "${INVB}            OT Scan                                        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Scans OT related stuff                         ${NC}"
      echo "${INVB}            this really will take some time                ${NC}"
      echo "${INVB}            OT is slow!                                    ${NC}"
      echo "${INVB}            Eyewitness needs to finish for usable results  ${NC}"
      echo "${INVB}            needs ipot.txt in input                        ${NC}"
      echo "${INVB}            is   ${RED}ipot.txt${RE}  present?                        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            start OT scan? ${GREEN}y${RE}/${RED}n${RE}                             ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/l10-otscan.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [mM])
      echo "${INVB}            Heiko Schotte, Firma Lausen                    ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Heiko is a Tatortreiniger.                     ${NC}"
      echo "${INVB}            He will clean up your mess!                    ${NC}"
      echo "${INVB}            This will barely leave a proof on this system! ${NC}"
      echo "${INVB}            All will be lost!                              ${NC}"
      echo "${INVB}            No Backup, no Sorry!                           ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/m10-cleaner.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [nN])
      echo "${INVB}            User Checks                                    ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Collection of Checks!                          ${NC}"
      echo "${INVB}            Will be LOUD!                                  ${NC}"
      echo "${INVB}            DNS Zone Transfer                              ${NC}"
      echo "${INVB}            Username as Password with CME                  ${NC}"
      echo "${INVB}            Creates BH import query for valid accounts     ${NC}"
      echo "${INVB}            GPP Autologin with CME                         ${NC}"
      echo "${INVB}            GPP Password with CME                          ${NC}"
      echo "${INVB}            Looting of GPP Checks in host.txt              ${NC}"
      echo "${INVB}            Check Pass-Pol with CME                        ${NC}"
      echo "${INVB}            Check nopac with CME                           ${NC}"
      echo "${INVB}            Check petitpotam with CME                      ${NC}"
      echo "${INVB}            Check DFScoerce with CME                       ${NC}"
      echo "${INVB}            Check Shacowcoerce with CME                    ${NC}"
      echo "${INVB}            Check ntlmv1 with CME                          ${NC}"
      echo "${INVB}            Check SMB sessions with CME                    ${NC}"
      echo "${INVB}            Check ASRep with CME                           ${NC}"
      echo "${INVB}            Check Kerberoasting with CME                   ${NC}"
      echo "${INVB}            Check MAQ with CME                             ${NC}"
      echo "${INVB}            Check ldap signing with CME and ldaprelaycheck ${NC}"
      echo "${INVB}            Makes Bloodhound dump                          ${NC}"
      echo "${INVB}            Makes Certipy dump for old-bloodhound          ${NC}"
      echo "${INVB}            CME LDAP Checks may be broken                  ${NC}"
      echo "${INVB}            CME may be broken u need to press ENTER often! ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Realy? ${GREEN}y${RE}/${RED}n${RE}?                                    ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/n10-user_checks.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [oO])
      echo "${INVB}            MSF Workspace                                  ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Set new MSF workspace for the Modules          ${NC}"
      echo "${INVB}            Set E-Mail for SMTP Checks in resource.txt     ${NC}"
      echo "${INVB}            creates files in input/msf                     ${NC}"
      echo "${INVB}            will NOT delete existing workspace!            ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            New Workspace? ${GREEN}y${RE}/${RED}n${RE}?                            ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/o10-workspace.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [pP])
      echo "${INVB}            Select Interface                               ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Set new Interface                              ${NC}"
      echo "${INVB}            Changes all Scripts in auto_pt                 ${NC}"
      echo "${INVB}            Default is ${YELLOW}eth0${RE}                                ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            New Interface? ${GREEN}y${RE}/${RED}n${RE}?                            ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/p10-interface.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [zZ])
      echo "${INVB}            Runtime                                        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            Opens runtime.txt in split-pane                ${NC}"
      echo "${INVB}            is following runtime.txt (auto refresh)        ${NC}"
      echo "${INVB}-----------------------------------------------------------${NC}"
      echo "${INVB}            view status? ${GREEN}y${RE}/${RED}n${RE}?                              ${NC}"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/z10-status.sh
            break
            ;;

          *)
            echo "${RED}go back${NC}"
            break
            ;;
        esac
      done
      continue
      ;;

    [0])
      break
      ;;

    *)
      echo ""
      echo "${INVB}            ${YELLOW}Select a valid option from the list!           ${NC}"
      echo ""
      ;;
  esac
done

figlet 'All Done'

exit 0
