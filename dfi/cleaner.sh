#!/bin/bash

echo -e "  _____           _____            _____ _                            "
echo -e " |  __ \         / ____|          / ____| |                           "
echo -e " | |__) | __ ___| (___   ___  ___| |    | | ___  __ _ _ __   ___ _ __ "
echo -e " |  ___/ \'__/ _ \\\___ \ / _ \/ __| |    | |/ _ \/ _\` | '_ \ / _ \ \'__|"
echo -e " | |   | | | (_) |___) |  __/ (__| |____| |  __/ (_| | | | |  __/ |   "
echo -e " |_|   |_|  \___/_____/ \___|\___|\_____|_|\___|\__,_|_| |_|\___|_|   "
echo ""
echo "! > Cleaning all!"
msfconsole -qx 'workspace -D; exit'

rm -r /root/input
rm -r /root/output
rm -r /root/.cme
rm -r /usr/share/responder/logs
rm -r /opt/PCredz/logs
rm /opt/PCredz/CredentialDump-Session.log
rm /root/.msf4/history
rm /root/.zsh_history
rm /root/.bash_history

echo "! > CLEAN!"
