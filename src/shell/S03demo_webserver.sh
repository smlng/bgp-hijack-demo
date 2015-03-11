#!/bin/bash
BASEDIR=$(pwd)
DEMOHOST="0.0.0.0"
DEMOPORT="8000"
BGPMON=/usr/local/bin/bgpmon
# check if directory correct
[ ! -d "$(pwd)/etc" ] && { echo "Missing config directory (etc)! Run from repo root!"; exit 1; }
[ ! -d "$(pwd)/src/python/www" ] && { echo "Missing source directory (src/python/www)! Run from repo root!"; exit 1; }
echo " - BASEDIR           [ OK ]"
sleep 5
while read SIGNAL; do
    case "$SIGNAL" in
        *RUN*)break;;
        *)echo "signal  $SIGNAL  is unsupported" >/dev/stderr;;
    esac
done < /tmp/demopipe
cd src/python/www
virtualenv demo
source demo/bin/activate
echo " - python init       [ OK ]"
pip install -r ../requirements.txt
echo " - python deps       [ OK ]"
python server -h $DEMOHOST -p $DEMOPORT
exit 0