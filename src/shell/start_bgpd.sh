#!/bin/sh

# path to bgpd binary, Debian default
BGPD=/usr/lib/quagga/bgpd

# base directory, default: within repo
# config directory
CDIR="../../etc/quagga"
# pid directory
PDIR="../../run/quagga"

# create pid dir, if necessary
mkdir -p $PDIR
chown -R quagga:quagga $PDIR

# start daemons
$BGPD -f $CDIR/AS65001.conf -i $PDIR/AS65001.pid -p 11179 -P 2001 &
$BGPD -f $CDIR/AS65002.conf -i $PDIR/AS65002.pid -p 12179 -P 2002 &
$BGPD -f $CDIR/AS65003.conf -i $PDIR/AS65003.pid -p 13179 -P 2003 &
$BGPD -f $CDIR/AS65004.conf -i $PDIR/AS65004.pid -p 14179 -P 2004 &
$BGPD -f $CDIR/AS65005.conf -i $PDIR/AS65005.pid -p 15179 -P 2005 &
$BGPD -f $CDIR/AS65006.conf -i $PDIR/AS65006.pid -p 16179 -P 2006 &
$BGPD -f $CDIR/AS65007.conf -i $PDIR/AS65007.pid -p 17179 -P 2007 &
