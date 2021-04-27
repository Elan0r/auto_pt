#!/bin/bash
echo ' _____           _____             __  __       _ _ _            _   '
echo '|  __ \         / ____|           |  \/  |     (_) | |          | |  '
echo '| |__) | __ ___| (___   ___  ___  | \  / | __ _ _| | |_ ___  ___| |_ '
echo '|  ___/ |__/ _ \\___ \ / _ \/ __| | |\/| |/ _` | | | __/ _ \/ __| __|'
echo '| |   | | | (_) |___) |  __/ (__  | |  | | (_| | | | ||  __/\__ \ |_ '
echo '|_|   |_|  \___/_____/ \___|\___| |_|  |_|\__,_|_|_|\__\___||___/\__|'
echo '                                                                     '

read -p "Sender Email: " from
echo "  "
read -p "Header From field: " field
echo " "
read -p "Receiver Email: " rcpt
echo " "
read -p "Subject: " sub
echo " "
read -p "Text: " data
echo " "
read -p "IP Address SMTP: " ip
echo " "
echo " "
swaks --ehlo mx.team-prosec.com --from $from --h-From: "$field" --h-Subject: "$sub" --body "$data" --to $rcpt --server $ip -tlso
