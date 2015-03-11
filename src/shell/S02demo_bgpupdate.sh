#!/bin/bash
BASEDIR=$(pwd)
BGPMON=/usr/local/bin/bgpmon
# check if directory correct
[ ! -d "$(pwd)/etc" ] && { echo "Missing config directory (etc)! Run from repo root!"; exit 1; }
[ ! -d "$(pwd)/src/python/bgp" ] && { echo "Missing source directory (src/python/bgp)! Run from repo root!"; exit 1; }
echo " - BASEDIR           [ OK ]"
sleep 5
while read SIGNAL; do
    case "$SIGNAL" in
        *RUN*)break;;
        *)echo "signal  $SIGNAL  is unsupported" >/dev/stderr;;
    esac
done < /tmp/demo_bgp_pipe
echo " - got signal to proceed ... wait 5s ..."
sleep 5
cd src/python/bgp
virtualenv demo
source demo/bin/activate
echo " - python init       [ OK ]"
pip install -r ../requirements.txt
echo " - python deps       [ OK ]"
python bgpmonUpdateParser.py -j | python broadcastServer.py
exit 0