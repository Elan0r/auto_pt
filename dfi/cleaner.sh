#!/bin/bash

echo "Deleting Metasploit Workspaces"

msfconsole -qx 'workspace -D; exit'

echo "Deleting Folders and Files"

rm -r /root/input
rm -r /root/output
rm -r /root/.cme
rm -r /usr/share/responder/logs
rm /root/.msf4/history
rm /root/.zsh_history
rm /root/bash_history

echo "CLEAN"
