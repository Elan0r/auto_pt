#!/bin/bash
echo -e ' _____           _____             __  __       _ _ _            _   '
echo -e '|  __ \         / ____|           |  \/  |     (_) | |          | |  '
echo -e '| |__) | __ ___| (___   ___  ___  | \  / | __ _ _| | |_ ___  ___| |_ '
echo -e '|  ___/ |__/ _ \\\___ \ / _ \/ __| | |\/| |/ _` | | | __/ _ \/ __| __|'
echo -e '| |   | | | (_) |___) |  __/ (__  | |  | | (_| | | | ||  __/\__ \ |_ '
echo -e '|_|   |_|  \___/_____/ \___|\___| |_|  |_|\__,_|_|_|\__\___||___/\__|'
echo -e '                                                                     '

read -p "External Mail: "  ext
echo -e "  "
read -p "Internal Mail: " int
echo -e " "
read -p "Subject: " sub
echo -e " "
read -p 'Text: ' data
echo -e " "
read -p "IP Address SMTP: " ip
echo -e " "
echo -e " "
#if [ ! -d /root/output/mail_test ]
#then
#	mkdir -p /root/output/mail_test
#else
#	echo -e ''
#fi
function single {
	eval sub=$3
	eval data=$4

	echo -e "Server: $5"
	echo -e "First check: \tExtern -> Intern"
	swaks --ehlo mx.team-prosec.com --from $1 --h-From: "$1" --h-Subject: "${sub}" --body "MailServer: $5 \n\n ${data}" --to $2 --server $5 -tlso > .ext_to_int_$5.txt
	echo -e "Second check: \tIntern -> Intern"
	swaks --ehlo mx.team-prosec.com --from $2 --h-From: "$2" --h-Subject: "${sub}" --body "MailServer: $5 \n\n ${data}" --to $2 --server $5 -tlso > .int_to_int_$5.txt
	echo -e "Third check: \tIntern -> Extern"
	swaks --ehlo mx.team-prosec.com --from $2 --h-From: "$2" --h-Subject: "${sub}" --body "MailServer: $5 \n\n ${data}" --to $1 --server $5 -tlso > .int_to_ext_$5.txt
	echo -e "Fourth check: \tExtern -> Extern"
	swaks --ehlo mx.team-prosec.com --from $1 --h-From: "$1" --h-Subject: "${sub}" --body "MailServer: $5 \n\n ${data}" --to $1 --server $5 -tlso > .ext_to_ext_$5.txt
	echo -e " "
	echo -e "Checks performed. Check output files for more information"
	echo -e " "
}

function file {
	eval sub=$3
	eval data=$4
	for i in $(cat $5)
	do
	single $1 $2 "\${sub}" "\${data}" $i
	done
}

if [ -e $ip ]
then
	file $ext $int "\${sub}" "\${data}" $ip

else
	single $ext $int "\${sub}" "\${data}" $ip
fi
