#!/bin/bash

# path to bgpd binary, Debian default
BGPMON=/usr/local/bin/bgpmon
SCRIPT=$(readlink $0)
BASEDIR=$(dirname $SCRIPT)
# base directory, default: within repo
# config directory
CDIR="$BASEDIR/../../etc"
LDIR="$BASEDIR/../../log"

mkdir -p $LDIR
# start daemon
$BGPMON -c $CDIR/bgpmon_config.txt 2>&1 > $LDIR/bgpmon &