#!/bin/bash
echo ' _____           _____             __  __       _ _ _            _   '
echo '|  __ \         / ____|           |  \/  |     (_) | |          | |  '
echo '| |__) | __ ___| (___   ___  ___  | \  / | __ _ _| | |_ ___  ___| |_ '
echo '|  ___/ |__/ _ \\___ \ / _ \/ __| | |\/| |/ _` | | | __/ _ \/ __| __|'
echo '| |   | | | (_) |___) |  __/ (__  | |  | | (_| | | | ||  __/\__ \ |_ '
echo '|_|   |_|  \___/_____/ \___|\___| |_|  |_|\__,_|_|_|\__\___||___/\__|'
echo '                                                                     '

read -p "External Mail: "  ext
echo "  "
read -p "Internal Mail: " int
echo " "
read -p "Subject: " sub
echo " "
read -p "Text: " data
echo " "
read -p "IP Address SMTP: " ip
echo " "
echo " "
echo "First check: Extern -> Intern"
swaks --ehlo mx.team-prosec.com --from $ext --h-From: "$ext" --h-Subject: "$sub" --body "$data" --to $int --server $ip -tlso > ext_to_int.txt
echo " "
echo "Second check: Intern -> Intern"
swaks --ehlo mx.team-prosec.com --from $int --h-From: "$int" --h-Subject: "$sub" --body "$data" --to $int --server $ip -tlso > int_to_int.txt
echo " "
echo "Third check: Intern -> Extern"
swaks --ehlo mx.team-prosec.com --from $int --h-From: "$int" --h-Subject: "$sub" --body "$data" --to $ext --server $ip -tlso > int_to_ext.txt
echo " "
echo "Fourth check: Extern -> Extern"
swaks --ehlo mx.team-prosec.com --from $ext --h-From: "$ext" --h-Subject: "$sub" --body "$data" --to $ext --server $ip -tlso > int_to_ext.txt
echo " "
echo "Checks performed. Check output files for more information"
