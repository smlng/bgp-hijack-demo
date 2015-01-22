# BGP Hijack Demonstrator -- SETUP

## start up

First create separate (TAP) interfaces with distinct IP addresses for BGPd and BGPmon:
    
    $ cd src/shell
    $ sudo ./create_taps.sh

Afterwards start BGP daemons:
    
    $ sudo ./start_bgpd.sh