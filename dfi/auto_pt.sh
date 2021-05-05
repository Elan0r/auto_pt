#!/bin/bash

chmod +x ./active_recon.sh
chmod +x ./msf.sh
chmod +x ./relay.sh
chmod +x ./eyewitness.sh

echo 'Start Active Recon'
./active_recon.sh
echo 'Start Metasploit'
./msf.sh
echo 'Start Relay'
./relay.sh
echo 'make some Screens'
./eyewitness.sh
echo 'PT Done xD'
