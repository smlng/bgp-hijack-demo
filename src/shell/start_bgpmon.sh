#!/bin/sh

# path to bgpd binary, Debian default
BGPMON=/usr/local/bin/bgpmon

# base directory, default: within repo
# config directory
CDIR="../../etc"
LDIR="../../log"

mkdir -p $LDIR
# start daemon
$BGPMON -c $CDIR/bgpmon_config.txt 2>&1 > $LDIR/bgpmon.log &
