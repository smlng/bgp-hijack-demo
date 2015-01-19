#!/bin/sh

BGPD=/usr/lib/quagga/bgpd

$BGPD -f /etc/quagga/AS65001.conf -i /run/quagga/AS65001.pid -p 11179 -P 2001 &
$BGPD -f /etc/quagga/AS65002.conf -i /run/quagga/AS65002.pid -p 12179 -P 2002 &
$BGPD -f /etc/quagga/AS65003.conf -i /run/quagga/AS65003.pid -p 13179 -P 2003 &
$BGPD -f /etc/quagga/AS65004.conf -i /run/quagga/AS65004.pid -p 14179 -P 2004 &
$BGPD -f /etc/quagga/AS65005.conf -i /run/quagga/AS65005.pid -p 15179 -P 2005 &
$BGPD -f /etc/quagga/AS65006.conf -i /run/quagga/AS65006.pid -p 16179 -P 2006 &
$BGPD -f /etc/quagga/AS65007.conf -i /run/quagga/AS65007.pid -p 17179 -P 2007 &
