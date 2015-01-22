#!/bin/sh

# path to bgpd binary, Debian default
BGPMON=/usr/local/bin/bgpmon

# base directory, default: within repo
# config directory
CDIR="../../etc/"

# start daemons
$BGPMON -c $CDIR/bgpmon_config1.txt -d &
$BGPMON -c $CDIR/bgpmon_config2.txt -d &
$BGPMON -c $CDIR/bgpmon_config3.txt -d &
