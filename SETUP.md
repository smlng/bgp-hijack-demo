# BGP Hijack Demonstrator -- SETUP

## introduction

For our demo setup we use a single node, i.e., desktop PC, to host all services we require. We use TAP interfaces with distinct IP addresses and ports to isolate communication of the BGP and BGPmon daemons on the network level. As everything is running on a single system, be careful using IPs or DNS names refering to _real_ interfaces such as `localhost` (`127.0.0.1`) or your public interface `eth0`. 

_Note_: you could easily spread out the deployment on multiple physical or virtual machines, if you like.

## BGP topology

The Quagga BGP daemons run on seperate virtual/alias IP interfaces with IPs `192.168.1.1` to `192.168.1.7` (`192.168.1.X`) and ports `11179` to `17179` (`1X179`). Each BGPd has its own _autonomous system_ (AS) with number `6500X` and an IP prefix `160.45.1XX.0/26`, with X = 1...7.

BGPmon uses virtual/alias IP interfaces with IPs `192.168.1.{100,101,102,103}`; we currently test 2 BGPmon setups: a) single instance, and b) multiple instances with CHAINs. For the latter (multi instances) use `etc/bgpmon_config{0,1,2,3}.txt` and for single instance setup use the `etc/bgpmon_config.txt`. BGPmon uses `AS65000` for monitoring of its peers.

The BGP topology of the ASes is as follows:
```
AS65001 ---- AS65002 ---- AS65003 ---- AS65004 
                  \                      / 
                   \                    /
                    \                  /
                     \                /  
AS65000             AS65005 ---- AS65006 ---- AS65007
```

## setup

First create separate (TAP) interfaces with distinct IP addresses for BGPd and BGPmon:
    
    $ cd src/shell
    $ sudo ./create_taps.sh

Afterwards start BGP daemons:
    
    $ sudo ./start_bgpd.sh