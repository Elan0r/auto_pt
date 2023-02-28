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
  read -r abcdefghijklmn0
  case $abcdefghijklmn0 in
    [aA])
      echo -e "\e[44;1m            Full install will take some time!!!            \e[0m"
      echo ""
      source /opt/auto_pt/scripts/a10-tool_install.sh
      break
      ;;

    [bB])
      echo -e "\e[44;1m            Folder Creation                                \e[0m"
      echo ""
      source /opt/auto_pt/scripts/b10-folder.sh
      continue
      ;;

    [cC])
      echo -e "\e[44;1m            Passive Listener                               \e[0m"
      echo ""
      source /opt/auto_pt/scripts/c10-passive_recon.sh
      continue
      ;;

    [dD])
      echo -e "\e[44;1m            Scope Present or not?                          \e[0m"
      echo -e "\e[44;1m            If not use DNSenum for Scope definition        \e[0m"
      echo -e "\e[44;1m            DNSEnum (d) or scope present (p)               \e[0m"
      echo -e "\e[44;1m            DNSenum and scanning (s)                       \e[0m"
      while true; do
        read -r dps
        case $dps in
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

          *)
            echo "Please answer D, P or S"
            ;;
        esac
      done
      continue
      ;;

    [eE])
      echo -e "\e[44;1m            Vulnerability Analysis (MSF+X)                 \e[0m"
      echo ""
      source /opt/auto_pt/scripts/o10-workspace.sh
      source /opt/auto_pt/scripts/e10-autosploit.sh
      source /opt/auto_pt/scripts/e11-zerocheck.sh
      source /opt/auto_pt/scripts/e12-log4check.sh
      source /opt/auto_pt/scripts/e13-rpc0check.sh
      source /opt/auto_pt/scripts/e14-def_creds.sh
      source /opt/auto_pt/scripts/e15-sslscan.sh
      source /opt/auto_pt/scripts/e16-relaylists.sh
      continue
      ;;

    [fF])
      echo -e "\e[44;1m            Responder Relay                                \e[0m"
      echo ""
      source /opt/auto_pt/scripts/f10-fast_relay.sh
      continue
      ;;

    [gG])
      echo -e "\e[44;1m            Looting                                        \e[0m"
      echo ""
      source /opt/auto_pt/scripts/g10-looter.sh
      continue
      ;;

    [hH])
      echo -e "\e[44;1m            Counting Loot                                  \e[0m"
      echo ""
      source /opt/auto_pt/scripts/h10-counter.sh
      continue
      ;;

    [iI])
      echo -e "\e[44;1m            Eyewitness                                     \e[0m"
      echo ""
      source /opt/auto_pt/scripts/i10-eyewitness.sh
      continue
      ;;

    [jJ])
      echo -e "\e[44;1m            Splash Screen looter                           \e[0m"
      echo ""
      source /opt/auto_pt/scripts/j10-def_screen_looter.sh
      continue
      ;;

    [kK])
      echo -e "\e[44;1m            ALL Auto_PT                                    \e[0m"
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
      echo -e "\e[44;1m            needs ipot.txt in input                        \e[0m"
      echo -e "\e[44;1m            is ipOT.txt    present?                        \e[0m"
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
      echo -e "\e[44;1m            Heiko Shotte Tatortreiniger                    \e[0m"
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
      echo -e "\e[44;1m            -u Username                                    \e[0m"
      echo -e "\e[44;1m            -p Password                                    \e[0m"
      echo -e "\e[44;1m            -d Domain                                      \e[0m"
      echo -e "\e[44;1m            -H Hash                                        \e[0m"
      echo -e "\e[44;1m            -i DC IP                                       \e[0m"
      echo -e "\e[44;1m            Hash OR Password is required                   \e[0m"
      echo ""
      read -p -r "enter parameter as usual: " INPUT
      source /opt/auto_pt/scripts/n10-user_checks.sh "$INPUT"
      break
      ;;

    [oO)
      echo -e "\e[44;1m            Set new MSF workspace                          \e[0m"
      echo ""
      source /opt/auto_pt/scripts/j10-def_screen_looter.sh
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
