#!/bin/bash
BASEDIR=$(pwd)
BGPMON=/usr/local/bin/bgpmon
# check if directory correct
[ ! -d "$(pwd)/etc" ] && { echo "Missing config directory (etc)! Run from repo root!"; exit 1; }
[ ! -d "$(pwd)/src/shell" ] && { echo "Missing source directory (src/shell)! Run from repo root!"; exit 1; }
echo " - BASEDIR           [ OK ]"
mkfifo /tmp/demopipe
echo " - create pipe       [ OK ]"
sudo ./src/shell/create_tabs.sh
echo " - create interfaces [ OK ]"
sudo ./src/shell/start_bgpd.sh
echo " - start bgp daemons [ OK ]"
sudo $BGPMON -c etc/bgpmon_config.txt
echo "RUN" > /tmp/demopipes
exit 0