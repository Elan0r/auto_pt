#!/bin/bash

# Start
while true; do
  echo '-----------------------------------------------------------'
  figlet Auto_PT
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94m\e[1mSelect an option from the list:                          \e[0m|"
  echo "|---------------------------------------------------------|"
  echo -e "|\e[94mA)\e[0m Tool Installer                                        |"
  echo -e "|\e[94mB)\e[0m Folder Creation                                       |"
  echo -e "|\e[94mC)\e[0m Passiv Listener                                       |"
  echo -e "|\e[94mD)\e[0m Host and Service Discovery                            |"
  echo -e "|\e[94mE)\e[0m Vulnerability Analysis (MSF+X)                        |"
  echo -e "|\e[94mF)\e[0m 5 min Responder Relay                                 |"
  echo -e "|\e[94mG)\e[0m Collect loot an RAW files                             |"
  echo -e "|\e[94mH)\e[0m Create Host.txt and Findings.txt                      |"
  echo -e "|\e[94mI)\e[0m Eyewitness scan all webservices                       |"
  echo -e "|\e[94mJ)\e[0m Collect default splash pages                          |"
  echo -e "|\e[94mK)\e[0m OT systems scan                                       |"
  echo -e "|\e[94mL)\e[0m Cleanup the mess                                      |"
  echo -e "|\e[94mM)\e[0m Run all exept OT and Cleaner                          |"
  echo -e "|\e[94mN)\e[0m Userchecks                                            |"
  echo -e "|\e[94m0)\e[0m Exit                                                  |"
  echo '-----------------------------------------------------------'
  read abcdefghijklmn0
  case $abcdefghijklmn0 in
    [aA] )
      echo -e "\e[44;1m            Full install will take some time!!!            \e[0m"
      echo ""
      source /opt/auto_pt/scripts/tool_install.sh
    break;;

    [bB] )
      echo -e "\e[44;1m            Folder Creation                                \e[0m"
      echo ""
      source /opt/auto_pt/scripts/folder.sh
    continue;;

    [cC] )
      echo -e "\e[44;1m            Passive Listener                               \e[0m"
      echo ""
      source /opt/auto_pt/scripts/passive_recon.sh
    continue;;

    [dD] )
      echo -e "\e[44;1m            Scope Present or not?                          \e[0m"
      echo -e "\e[44;1m            If not use DNSenum for Scope definition        \e[0m"
      echo -e "\e[44;1m            DNSEnum (d) or scope present (p)               \e[0m"
      echo -e "\e[44;1m            DNSenum and scanning (s)                       \e[0m"
      while true; do
        read dps
          case $dps in
            [dD]* ) source /opt/auto_pt/scripts/dns_enum.sh
          break;;

            [pP]* ) source /opt/auto_pt/scripts/active_recon.sh
          break;;

            [sS]* ) source /opt/auto_pt/scripts/dns_enum.sh
            source /opt/auto_pt/scripts/active_recon.sh
          break;;

            * ) echo "Please answer D, P or S";;
          esac
        done
    continue;;

    [eE] )
      echo -e "\e[44;1m            Vulnerability Analysis (MSF+X)                 \e[0m"
      echo ""
      source /opt/auto_pt/scripts/autosploit.sh
      source /opt/auto_pt/scripts/zerocheck.sh
      source /opt/auto_pt/scripts/log4check.sh
      source /opt/auto_pt/scripts/rpc0check.sh
    continue;;

    [fF] )
      echo -e "\e[44;1m            Responder Relay                                \e[0m"
      echo ""
      source /opt/auto_pt/scripts/fast_relay.sh
    continue;;

    [gG] )
      echo -e "\e[44;1m            Looting                                        \e[0m"
      echo ""
      source /opt/auto_pt/scripts/looter.sh
    continue;;

    [hH] )
      echo -e "\e[44;1m            Counting Loot                                  \e[0m"
      echo ""
      source /opt/auto_pt/scripts/counter.sh
    continue;;

    [iI] )
      echo -e "\e[44;1m            Eyewitness                                     \e[0m"
      echo ""
      source /opt/auto_pt/scripts/eyewitness.sh
    continue;;

    [jJ] )
      echo -e "\e[44;1m            Splash Screen looter                           \e[0m"
      echo ""
      source /opt/auto_pt/scripts/def_screen_looter.sh
    continue;;

    [kK] )
      echo -e "\e[44;1m            OT Scan                                        \e[0m"
      echo ""
      source /opt/auto_pt/scripts/otscan.sh
    continue;;

    [lL] )
      echo -e "\e[44;1m            Heiko Shotte Tatortreiniger                    \e[0m"
      echo -e "\e[44;1m            Realy? y/n?                                    \e[0m"
      echo ""
      while true; do
        read yn
          case $yn in
          [yY]* )
            source /opt/auto_pt/scripts/cleaner.sh
          break;;

          * )
            echo "go back"
          break;;
        esac
      done
    continue;;

    [mM )
      echo -e "\e[44;1m            ALL Auto_PT                                    \e[0m"
      echo -e "\e[44;1m            Realy? y/n?                                    \e[0m"
      echo ""
      while true; do
        read yn
          case $yn in
          [yY]* )
            source /opt/auto_pt/scripts/dns_enum.sh
            source /opt/auto_pt/scripts/active_recon.sh
            source /opt/auto_pt/scripts/autosploit.sh
            source /opt/auto_pt/scripts/zerocheck.sh
            source /opt/auto_pt/scripts/log4check.sh
            source /opt/auto_pt/scripts/rpc0check.sh
            source /opt/auto_pt/scripts/fast_relay.sh
            source /opt/auto_pt/scripts/looter.sh
            source /opt/auto_pt/scripts/counter.sh
            source /opt/auto_pt/scripts/eyewitness.sh
            source /opt/auto_pt/scripts/def_screen_looter.sh
          break;;

          [nN]* )
            echo "go back"
          break;;
        esac
      done
    continue;;

    [nN] )
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
    break;;

    [0] )
    break;;

    * ) echo ""
      echo -e "\e[44;1m            Select a valid option from the list!           \e[0m"
      echo "";;
    esac
done

figlet 'All Done'

exit 0
