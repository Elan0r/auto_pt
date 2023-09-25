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

#FUNCTIONS
set_mail_rcpt() {
  read -r -p "Recipiant E-Mail-Adress: " RCPT
  #check valide Mail
  if [[ ${RCPT} =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Valid E-Mail format"
  else
    echo "Invalid E-Mail format"
    exit 1
  fi
  #dig possible mailserver
  dig mx +short "${RCPT//*@/}" @9.9.9.9
  read -r -p "Recipiant E-Mail-Server: " RCPTSERVER
  echo ""
}

set_mail_from() {
  read -r -p "Sender E-Mail-Adress: " FROM
  #check valide Mail
  if [[ ${FROM} =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Valid E-Mail format"
  else
    echo "Invalid E-Mail format"
    exit 1
  fi
  #dig possible mailserver
  dig mx +short "${FROM//*@/}" @9.9.9.9
  read -r -p "Sender E-Mail-Server: " FROMSERVER
  echo ""
}

mail_eicar() {
  {
    echo "EICAR Mails Start"
    date
  } >>/root/output/runtime.txt
  for i in /opt/auto_pt/resources/mail_test/files/*; do
    [[ -e "$i" ]] || break
    swaks --ehlo "${FROMSERVER}" --from "${FROM}" --h-From: 'Mailtester' --h-Subject: "Attachmenttest EICAR File ${i//*\//}" --body "EICAR Testfile: ${i//*\//}" --to "${RCPT}" --server "${RCPTSERVER}" -tlso --suppress-data --attach @"$i" --attach-type "$(file --mime-type "$i" | awk '// {print$2}')" | tee /root/output/loot/mail/log/file_"${i//*\//}"_"$DATE".txt
    echo ""
    sleep 2
  done
  {
    echo "END EICAR Mails"
    date
  } >>/root/output/runtime.txt
}

mail_other() {
  {
    echo "Other Mails Start"
    date
  } >>/root/output/runtime.txt
  for i in /opt/auto_pt/resources/mail_test/files/*; do
    [[ -e "$i" ]] || break
    swaks --ehlo "${FROMSERVER}" --from "${FROM}" --h-From: 'Mailtester' --h-Subject: "Attachmenttest File ${i//*\//}" --body "Testfile: ${i//*\//}" --to "${RCPT}" --server "${RCPTSERVER}" -tlso --suppress-data --attach @"$i" --attach-type "$(file --mime-type "$i" | awk '// {print$2}')" | tee /root/output/loot/mail/log/file_"${i//*\//}"_"$DATE".txt
    echo ""
    sleep 2
  done
  {
    echo "END Other Mails"
    date
  } >>/root/output/runtime.txt
}

#START
figlet MailTest

#FolderCheck
echo 'Folder for files is /opt/auto_pt/resources/mail_test/files and eicar'
if test -e /opt/auto_pt/resources/mail_test/files && test -n "$(find /opt/auto_pt/resources/mail_test/files -maxdepth 1 -type f -name '*')"; then
  echo "Directory /opt/auto_pt/resources/mail_test/files contains files"
else
  echo "/opt/auto_pt/resources/mail_test/files is empty or does not exist"
fi
if test -e /opt/auto_pt/resources/mail_test/eicar && test -n "$(find /opt/auto_pt/resources/mail_test/eicar -maxdepth 1 -type f -name '*')"; then
  echo "Directory /opt/auto_pt/resources/mail_test/eicar contains files"
else
  echo "/opt/auto_pt/resources/mail_test/eicar is empty or does not exist"
fi
echo ""

set_mail_rcpt
set_mail_from
DATE=$(date +%F_%H-%M-%S)

while true; do
  echo -e "${CYAN}-----------------------------------------------------------${RED}"
  figlet '**MailTest**'
  echo -e "${GREEN}by @Elan0r"
  echo -e "${CYAN}|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Select an option from the list:${CYAN}                         |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}D${CYAN} Change Mail and Server                                |"
  echo -e "${CYAN}|---------------------------------------------------------|"
  echo -e "| ${PURPLE}M${CYAN} Mailtest only                                         |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Attachments${CYAN}                                             |"
  echo -e "| ${PURPLE}E${CYAN} Eicar only                                            |"
  echo -e "| ${PURPLE}O${CYAN} Other Files                                           |"
  echo -e "| ${PURPLE}A${CYAN} Eicar and Other Files                                 |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${PURPLE}0${RED} Exit${CYAN}                                                  |"
  echo -e "|---------------------------------------------------------|"
  echo -e "| ${YELLOW}Data${CYAN}                                                    |"
  echo -e "| Selected FromServer ${GREEN} ${FROMSERVER} ${CYAN}"
  echo -e "| Selected From       ${GREEN} ${FROM} ${CYAN}"
  echo -e "| Selected RcptServer ${GREEN} ${RCPTSERVER} ${CYAN}"
  echo -e "| Selected Rcpt       ${GREEN} ${RCPT} ${CYAN}"
  echo -e "|---------------------------------------------------------|${NC}"
  echo ""
  read -r deoam0
  case $deoam0 in
    [dD])
      echo -e "Change DATA"
      echo -e "Chcange Recipiant? ${YELLOW}R${NC}"
      echo -e "Chcange Sender? ${YELLOW}F${NC}"
      echo -e "Go Back ${YELLOW}N${NC}"
      while true; do
        read -r frn
        case $frn in
          [rR])
            set_mail_rcpt
            break
            ;;

          [fF])
            set_mail_from
            break
            ;;

          [nN])
            echo 'go back'
            break
            ;;

          *)
            echo -e "${CYAN}Please answer ${YELLOW}R ${CYAN}or ${YELLOW}F ${CYAN}or ${RED}N${NC}"
            ;;
        esac
      done
      continue
      ;;

    [eE])
      echo 'EICAR only'
      echo -e "is this correct? ${GREEN}y${NC}/${RED}n${NC}"
      while true; do
        read -r y
        case $y in
          [yY]*)
            mail_eicar
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

    [oO])
      echo 'Other Files only'
      echo -e "is this correct? ${GREEN}y${NC}/${RED}n${NC}"
      while true; do
        read -r y
        case $y in
          [yY]*)
            mail_other
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

    [aA])
      echo 'All Files'
      echo -e "is this correct? ${GREEN}y${NC}/${RED}n${NC}"
      while true; do
        read -r y
        case $y in
          [yY]*)
            mail_other
            mail_eicar
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

    [mM])
      echo -e "Mail Test only"
      echo -e "is this correct? ${GREEN}y${NC}/${RED}n${NC}"
      while true; do
        read -r y
        case $y in
          [yY]*)
            {
              echo "Start Mail Relay test"
              date
            } >>/root/output/runtime.txt
            echo 'Customer Mail (int) will be' "${RCPT}"
            echo ' Own Mail (ext) will be' "${FROM}"
            echo -e "First check: \t${FROM} -> ${RCPT}"
            swaks --ehlo "${FROMSERVER}" --from "${FROM}" --h-From 'Mailtester' --h-Subject: "Mailtest intern to extern" --body "MailServer: ${RCPTSERVER}" --to "${RCPT}" --server "${RCPTSERVER}" -tlso >/root/output/loot/mail/log/ext_to_int_"${RCPTSERVER}".txt
            echo -e "Second check: \t${RCPT} -> ${RCPT}"
            swaks --ehlo "${FROMSERVER}" --from "${RCPT}" --h-From: "Mailtester" --h-Subject: "Mailtest intern to intern" --body "MailServer: ${RCPTSERVER}" --to "${RCPT}" --server "${RCPTSERVER}" -tlso >/root/output/loot/mail/log/int_to_int_"${RCPTSERVER}".txt
            echo -e "Third check: \t${RCPT} -> ${FROM}"
            swaks --ehlo "${FROMSERVER}" --from "${RCPT}" --h-From: "${RCPT}" --h-Subject: "Mailtest intern to extern" --body "MailServer: ${RCPTSERVER}" --to "${FROM}" --server "${RCPTSERVER}" -tlso >/root/output/loot/mail/log/int_to_ext_"${RCPTSERVER}".txt
            echo -e "Fourth check: \t${FROM} -> ${FROM}"
            swaks --ehlo "${FROMSERVER}" --from "${FROM}" --h-From: "${FROM}" --h-Subject: "Mailtest extern to extern" --body "MailServer: ${RCPTSERVER}" --to "${FROM}" --server "${RCPTSERVER}" -tlso >/root/output/loot/mail/log/ext_to_ext_"${RCPTSERVER}".txt
            echo -e " "
            {
              echo "END Mail Relay test"
              date
            } >>/root/output/runtime.txt
            echo -e "Checks performed. Check output files for more information"
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

    [0])
      break
      ;;

    *)
      echo ""
      echo -e "${YELLOW}Select a valid option from the list!${NC}"
      ;;
  esac
done

echo -e "${BLUE}"
figlet 'Mailcheck Done'
echo -e "${NC}"
