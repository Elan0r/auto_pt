#!/bin/bash

figlet ChangeInterface

if test -e /opt/auto_pt/scripts && test -n "$(find /opt/auto_pt/scripts -maxdepth 1 -type f -name '*')"; then
  echo "Directory scripts contains files"
else
  echo "/opt/auto_pt/scripts is empty or does not exist"
  exit 1
fi

read -r -p "Enter OLD interface (previous eth0): " OLD
read -r -p "Enter interface to use: " NEW

sed -i "s/$OLD/$NEW/g" /opt/auto_pt/scripts/*.sh

echo 'new interface is' "$NEW"
