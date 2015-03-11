#!/bin/bash
BASEDIR=$(pwd)
BGPMON=/usr/local/bin/bgpmon
# check if directory correct
[ ! -d "$(pwd)/etc" ] && { echo "Missing config directory (etc)! Run from repo root!"; exit 1; }
[ ! -d "$(pwd)/src/shell" ] && { echo "Missing source directory (src/shell)! Run from repo root!"; exit 1; }
echo " - BASEDIR           [ OK ]"
mkfifo /tmp/demo_bgp_pipe
mkfifo /tmp/demo_www_pipe
echo " - create pipe       [ OK ]"
sudo ./src/shell/create_taps.sh
echo " - create interfaces [ OK ]"
sudo ./src/shell/start_bgpd.sh
sleep 7
echo " - start bgp daemons [ OK ]"
echo "RUN" > /tmp/demo_bgp_pipe
sleep 1
echo "RUN" > /tmp/demo_www_pipe
sleep 2
rm -rf /tmp/demo_www_pipe
rm -rf /tmp/demo_bgp_pipe
sudo $BGPMON -c etc/bgpmon_config.txt
exit 0