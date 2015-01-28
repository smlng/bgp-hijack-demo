# BGP Hijack Demonstrator -- SETUP

## introduction

For our demo setup we use a single node, i.e., desktop PC, to host all services we require. We use TAP interfaces with distinct IP addresses and ports to isolate communication of the BGP and BGPmon daemons on the network level. As everything is running on a single system, be careful using IPs or DNS names refering to _real_ interfaces such as `localhost` (`127.0.0.1`) or your public interface `eth0`. 

_Note_: you could easily spread out the deployment on multiple physical or virtual machines, if you like.

## BGP topology

The 7 Quagga BGP daemons run on seperate virtual/alias IP interfaces with IPs `192.168.1.1` - `192.168.1.7` and ports `11179` - `17179`. Each BGPd has its own _autonomous system_ (AS) with numbers `65001` - `65007` and an IP prefixes `160.45.111.0/26` - `160.45.177.0/26`.

BGPmon uses virtual/alias IP interfaces with IPs `192.168.1.{100,101,102,103}`. We are currently testing 2 BGPmon setups: 

- single instance (unstable), and 
- multiple instances with CHAINs 

For the latter we use `etc/bgpmon_config{0,1,2,3}.txt` and for single instance setup its `etc/bgpmon_config.txt`. BGPmon requires its own AS (`AS65000`) for monitoring of its peers.

The BGP topology for the demo setup is as follows:

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