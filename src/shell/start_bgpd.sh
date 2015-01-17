#!/bin/bash

BGPD=/usr/lib/quagga/bgpd

$BGPD -f /etc/quagga/AS65001.conf -i /run/quagga/AS65001.pid -P 2001 &
$BGPD -f /etc/quagga/AS65002.conf -i /run/quagga/AS65002.pid -P 2002 &
$BGPD -f /etc/quagga/AS65003.conf -i /run/quagga/AS65003.pid -P 2003 &
$BGPD -f /etc/quagga/AS65004.conf -i /run/quagga/AS65004.pid -P 2004 &
$BGPD -f /etc/quagga/AS65005.conf -i /run/quagga/AS65005.pid -P 2005 &
$BGPD -f /etc/quagga/AS65006.conf -i /run/quagga/AS65006.pid -P 2006 &
$BGPD -f /etc/quagga/AS65007.conf -i /run/quagga/AS65007.pid -P 2007 &
