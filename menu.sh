#!/bin/bash

# create nessesary folder
/opt/auto_pt/scripts/b10-folder.sh

#rename Window
tmux rename-window '**Auto PT**'

# shellcheck disable=SC1091
while true; do
  echo '-----------------------------------------------------------'
  figlet '**Auto PT**'
  echo "|---------------------------------------------------------|"
  echo "|All Scripts are tracked in runtime.txt in output         |"
  echo "|Details of all Scripts in SubMenu                        |"
  echo -e "|\e[94m\e[1mSelect an option from the list:                          \e[0m|"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mA)\e[0m Tool Installer                                        |"
  echo -e "|\e[94mB)\e[0m Folder Re-Creation                                    |"
  echo -e "|\e[94mC)\e[0m Passiv Listener                                       |"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mD)\e[0m Host and Service Discovery                            |"
  echo -e "|\e[94mE)\e[0m Vulnerability Analysis (MSF+X)                        |"
  echo -e "|\e[94mF)\e[0m 5 min Responder Relay                                 |"
  echo -e "|\e[94mG)\e[0m Collect loot an RAW files                             |"
  echo -e "|\e[94mH)\e[0m Create Host.txt and Findings.txt                      |"
  echo -e "|\e[94mI)\e[0m Eyewitness scan all webservices                       |"
  echo -e "|\e[94mJ)\e[0m Collect default splash pages                          |"
  echo -e "|\e[94mK)\e[0m Run all above exept installer and passiv              |"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mL)\e[0m OT systems scan                                       |"
  echo -e "|\e[94mM)\e[0m Cleanup the mess                                      |"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mN)\e[0m Userchecks (Creds required!)                          |"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mO)\e[0m Set Workspace                                         |"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94m0)\e[0m Exit                                                  |"
  echo '-----------------------------------------------------------'
  read -r abcdefghijklmno0
  case $abcdefghijklmno0 in
    [aA])
      echo -e "\e[44;1m            Tool Installer                                 \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Ths script will install common used tools      \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start installation? y/n                        \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/a10-tool_install.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [bB])
      echo -e "\e[44;1m            Folder Creation                                \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Ths script will create folders if not present  \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start creation? y/n                            \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/b10-folder.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [cC])
      echo -e "\e[44;1m            Passive Listener                               \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Ths script will start passive Recon            \e[0m"
      echo -e "\e[44;1m            Netdiscover for quick host and network view    \e[0m"
      echo -e "\e[44;1m            PCredz for hash collection                     \e[0m"
      echo -e "\e[44;1m            tcpdump for further traffic analysis           \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start listener? y/n                            \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/c10-passive_recon.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [dD])
      echo -e "\e[44;1m            Active Recon                                   \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            This script will scann all networks            \e[0m"
      echo -e "\e[44;1m            can create Scope for check with customer       \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            DNSenum with nmap sL scan all private IPs      \e[0m"
      echo -e "\e[44;1m            nmap PE and sO for Host Discovery              \e[0m"
      echo -e "\e[44;1m            nmap sSV -O for Service and OS detection       \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Creates Info Gathering summary in output       \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Scope Present or not?                          \e[0m"
      echo -e "\e[44;1m            If not use DNSenum for Scope definition        \e[0m"
      echo -e "\e[44;1m            DNSEnum (d) or ActiveRecon only (p)            \e[0m"
      echo -e "\e[44;1m            DNSenum and ActiveRecon (s)                    \e[0m"
      echo -e "\e[44;1m            Back to Main Menu (x)                          \e[0m"
      while true; do
        read -r dpsx
        case $dpsx in
          [dD]*)
            source /opt/auto_pt/scripts/d10-dns_enum.sh
            break
            ;;

          [pP]*)
            source /opt/auto_pt/scripts/d11-active_recon.sh
            break
            ;;

          [sS]*)
            source /opt/auto_pt/scripts/d10-dns_enum.sh
            source /opt/auto_pt/scripts/d11-active_recon.sh
            break
            ;;

          [xX]*)
            echo "go back"
            break
            ;;

          *)
            echo "Please answer D, P, S or X"
            ;;
        esac
      done
      continue
      ;;

    [eE])
      echo -e "\e[44;1m            Vulnerability Analysis (MSF+X)                 \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Ths script will start VA                       \e[0m"
      echo -e "\e[44;1m            Netdiscover for quick host and network view    \e[0m"
      echo -e "\e[44;1m            PCredz for hash collection                     \e[0m"
      echo -e "\e[44;1m            tcpdump for further traffic analysis           \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start VA? y/n                                  \e[0m"
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
            source /opt/auto_pt/scripts/e15-sslscan.sh
            source /opt/auto_pt/scripts/e16-relaylists.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [fF])
      echo -e "\e[44;1m            Responder Relay                                \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            This Script starts Responder -wbFP on eth0     \e[0m"
      echo -e "\e[44;1m            Ntlmrelyx versus all smb_no_signing            \e[0m"
      echo -e "\e[44;1m            If missing it will create a list               \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start relay? y/n                               \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [gG])
      echo -e "\e[44;1m            Looting                                        \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Collects all loot from previous scripts        \e[0m"
      echo -e "\e[44;1m            Creates hosts.txt for each finding             \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start looting? y/n                             \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/g10-looter.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [hH])
      echo -e "\e[44;1m            Counting Loot                                  \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Counts all loot                                \e[0m"
      echo -e "\e[44;1m            Creates findings.txt in output                 \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start counting? y/n                            \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/h10-counter.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [iI])
      echo -e "\e[44;1m            Eyewitness                                     \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Makes screens of all websites                  \e[0m"
      echo -e "\e[44;1m            uses nmap service.xml from active recon        \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start photosession? y/n                        \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [jJ])
      echo -e "\e[44;1m            Splash Screen looter                           \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Collect all Splashscreens from eyewitness      \e[0m"
      echo -e "\e[44;1m            Creates hosts.txt for each finding             \e[0m"
      echo -e "\e[44;1m            attaches result in findings.txt in output      \e[0m"
      echo -e "\e[44;1m            Eyewitness needs to finish for usable results  \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Start looting? y/n                             \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          *)
            echo 'go back'
            break
            ;;
        esac
      done
      continue
      ;;

    [kK])
      echo -e "\e[44;1m            Auto_PT                                        \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            All AutoPT scripts                             \e[0m"
      echo -e "\e[44;1m            Pre-set the MSF workspace with the O menu      \e[0m"
      echo -e "\e[44;1m            Main Menu D till J                             \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Workspace set?                                 \e[0m"
      echo -e "\e[44;1m            Realy? y/n?                                    \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            echo -e "\e[44;1m            Scope Present or not?                          \e[0m"
            echo -e "\e[44;1m            If not use DNSenum for Scope definition        \e[0m"
            echo -e "\e[44;1m            DNSEnum (d) or scope present (p)               \e[0m"
            while true; do
              read -r dp
              case $dp in
                [dD]*)
                  source /opt/auto_pt/scripts/d10-dns_enum.sh
                  break
                  ;;

                [pP]*)
                  break
                  ;;
              esac
            done

            source /opt/auto_pt/scripts/d11-active_recon.sh
            source /opt/auto_pt/scripts/e10-autosploit.sh
            source /opt/auto_pt/scripts/e11-zerocheck.sh
            source /opt/auto_pt/scripts/e12-log4check.sh
            source /opt/auto_pt/scripts/e13-rpc0check.sh
            source /opt/auto_pt/scripts/e14-def_creds.sh
            source /opt/auto_pt/scripts/e15-sslscan.sh
            source /opt/auto_pt/scripts/e16-relaylists.sh
            source /opt/auto_pt/scripts/f10-fast_relay.sh
            source /opt/auto_pt/scripts/g10-looter.sh
            source /opt/auto_pt/scripts/h10-counter.sh
            source /opt/auto_pt/scripts/i10-eyewitness.sh
            source /opt/auto_pt/scripts/j10-def_screen_looter.sh
            break
            ;;

          *)
            echo "go back"
            break
            ;;
        esac
      done
      continue
      ;;

    [lL])
      echo -e "\e[44;1m            OT Scan                                        \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Scans OT related stuff                         \e[0m"
      echo -e "\e[44;1m            this really will take some time                \e[0m"
      echo -e "\e[44;1m            OT is slow!                                    \e[0m"
      echo -e "\e[44;1m            Eyewitness needs to finish for usable results  \e[0m"
      echo -e "\e[44;1m            needs ipot.txt in input                        \e[0m"
      echo -e "\e[44;1m            is ipOT.txt    present?                        \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            start OT scan? y/n                             \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/l10-otscan.sh
            break
            ;;

          *)
            echo "go back"
            break
            ;;
        esac
      done
      continue
      ;;

    [mM])
      echo -e "\e[44;1m            Heiko Schotte, Firma Lausen                    \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Heiko is a Tatortreiniger.                     \e[0m"
      echo -e "\e[44;1m            He will clean up your mess!                    \e[0m"
      echo -e "\e[44;1m            This will barely leave a proof on this system! \e[0m"
      echo -e "\e[44;1m            All will be lost!                              \e[0m"
      echo -e "\e[44;1m            No Backup, no Sorry!                           \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Realy? y/n?                                    \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/m10-cleaner.sh
            break
            ;;

          *)
            echo "go back"
            break
            ;;
        esac
      done
      continue
      ;;

    [nN])
      echo -e "\e[44;1m            User Checks                                    \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Collection of Checks!                          \e[0m"
      echo -e "\e[44;1m            Will be LOUD!                                  \e[0m"
      echo -e "\e[44;1m            DNS Zone Transfer                              \e[0m"
      echo -e "\e[44;1m            Username as Password with CME                  \e[0m"
      echo -e "\e[44;1m            Creates BH import query for valid accounts     \e[0m"
      echo -e "\e[44;1m            GPP Autologin with CME                         \e[0m"
      echo -e "\e[44;1m            GPP Password with CME                          \e[0m"
      echo -e "\e[44;1m            Looting of GPP Checks in host.txt              \e[0m"
      echo -e "\e[44;1m            Check Pass-Pol with CME                        \e[0m"
      echo -e "\e[44;1m            Check nopac with CME                           \e[0m"
      echo -e "\e[44;1m            Check petitpotam with CME                      \e[0m"
      echo -e "\e[44;1m            Check DFScoerce with CME                       \e[0m"
      echo -e "\e[44;1m            Check Shacowcoerce with CME                    \e[0m"
      echo -e "\e[44;1m            Check ntlmv1 with CME                          \e[0m"
      echo -e "\e[44;1m            Check SMB sessions with CME                    \e[0m"
      echo -e "\e[44;1m            Check ASRep with CME                           \e[0m"
      echo -e "\e[44;1m            Check Kerberoasting with CME                   \e[0m"
      echo -e "\e[44;1m            Check MAQ with CME                             \e[0m"
      echo -e "\e[44;1m            Check ldap signing with CME and ldaprelaycheck \e[0m"
      echo -e "\e[44;1m            Makes Bloodhound dump                          \e[0m"
      echo -e "\e[44;1m            Makes Certipy dump for old-bloodhound          \e[0m"
      echo -e "\e[44;1m            CME LDAP Checks may be broken                  \e[0m"
      echo -e "\e[44;1m            CME may be broken u need to press ENTER often! \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Realy? y/n?                                    \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/n10-user_checks.sh
            break
            ;;

          *)
            echo "go back"
            break
            ;;
        esac
      done
      continue
      ;;

    [oO)
      echo -e "\e[44;1m            MSF Workspace                                  \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            Set new MSF workspace for the Modules          \e[0m"
      echo -e "\e[44;1m            creates files in input/msf                     \e[0m"
      echo -e "\e[44;1m            will NOT delete existing!                      \e[0m"
      echo -e "\e[44;1m-----------------------------------------------------------\e[0m"
      echo -e "\e[44;1m            New Workspace? y/n?                            \e[0m"
      echo ""
      while true; do
        read -r y
        case $y in
          [yY]*)
            source /opt/auto_pt/scripts/o10-workspace.sh
            break
            ;;

          *)
            echo "go back"
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
      echo -e "\e[44;1m            Select a valid option from the list!           \e[0m"
      echo ""
      ;;
  esac
done

figlet 'All Done'

exit 0
