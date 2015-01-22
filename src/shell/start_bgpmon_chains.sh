#!/bin/sh

# path to bgpd binary, Debian default
BGPMON=/usr/local/bin/bgpmon

# base directory, default: within repo
# config directory
CDIR="../../etc"
LDIR="../../log"

mkdir -p $LDIR
# start daemons
$BGPMON -c $CDIR/bgpmon_config1.txt 2>&1 > $LDIR/bgpmon1.log &
$BGPMON -c $CDIR/bgpmon_config2.txt 2>&1 > $LDIR/bgpmon2.log &
$BGPMON -c $CDIR/bgpmon_config3.txt 2>&1 > $LDIR/bgpmon3.log &
