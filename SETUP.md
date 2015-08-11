# BGP Hijack Demonstrator -- SETUP

## introduction

For our demo setup we use a single node, i.e., desktop PC, to host all services.
We use tunnel interfaces (TAP) with distinct IP addresses and ports to isolate
communication of the BGP and BGPmon daemons on the network level. As everything
is running on a single system, be careful using IPs or DNS names that refer to
_real_ interfaces such as `localhost` (`127.0.0.1`) or an interface like `eth0`.

_Note_: you could easily spread out the deployment on multiple physical or
virtual machines, if you like.

## BGP topology

The BGP topology for the demo setup is as follows:

```
AS65001 ---- AS65002 ---- AS65003 ---- AS65004
                  \                      /
                   \                    /
                    \                  /
                     \                /  
AS65000             AS65005 ---- AS65006 ---- AS65007
```

The 7 Quagga BGP daemons run on seperate virtual/alias IP interfaces with IPs
`10.168.1.1` - `10.168.1.7` and ports `11179` - `17179`. Each BGPd has its own
_autonomous system_ (AS) with numbers `65001` - `65007` and an IP prefixes
`160.45.111.0/26` - `160.45.177.0/26`.

BGPmon also uses a virtual/alias IP interfaces with IP `10.168.1.100`.  Its
configuration is in `etc/bgpmon_config.txt`. Further, BGPmon requires its own AS
 (`AS65000`) for monitoring of its peers.


## preliminaries

The demo setup has depencencies that must be met before running the demo:

- install quagga bgp, check path to binary in `src/shell/start_bgpd.sh`.
- compile (and install) bgpmon, check path to binary in
`src/shell/S01demo_init.sh`, and `src/shell/start_bgpmon.sh`.
- _Note_: the demo uses SNMP and will overwrite your system local SNMP daemon
configuration (`/etc/snmp/snmpd.conf`). If you have a custom SNMP daemon config,
you should either backup this config and/or setup the demo manually.
- If you want to extend the demo with RPKI verification, read the description
in RPKI.md

## setup

We recommend using multiple terminal/shell sessions to start and monitor the
demo, e.g., using `screen` or `tmux`. _Note_: all following commands are run
from the root directory of the demo repository. You should not run the demo as
root user, however sudo rights are necessary.

For ease of deployment we provide a screen config to start the demo, run:

    $ screen -c etc/screenrc

_Note_: navigate through all tabs using `ctrl+a+[0-4]`, i.e., goto the first
screen tab with `ctrl+a+1` - sudo requires your password. The following tabs
are created:
- 0: htop
- 1: bgpmon daemon foreground, creates also taps, starts quagga bgpd, and
modifies snmpd.conf
- 2: bgp update parser and websocket broadcaster
- 3: webserver
- 4: empty shell/bash

-----

Or start the demo manually, as follows:

First, create separate (TAP) interfaces with distinct IP addresses for BGPd
and BGPmon:

    $ sudo ./src/shell/create_taps.sh

Second, start the BGP daemons using a helper script:

    $ sudo ./src/shell/start_bgpd.sh

Third, fire up BGPmon (assuming its installed, otherwise run with absolute path):

  $ sudo bgpmon -c etc/bgpmon_config.txt

You may also run BGPmon in background, logs are writen to `log/bgpmon`:

  $ sudo ./src/shell/start_bgpmon.sh

Forth, edit `etc/snmp/snmpd.conf` replace `<path-to-repo>` with absolute path
to demo repo. Afterwards replace the systems `snmpd.conf` and restart the snmpd
service

  $ sudo cp etc/snmp/snmpd.conf /etc/snmp/snmpd.conf
  $ sudo systemctl restart snmpd.service

Next, start all webservices

* create python environment
```
$ cd src/python
$ virtualenv local
$ source local/bin/activate
$ pip install -r requirements
```

* run bgp update parser and websocket server
```
$ cd bgp
$ python bgpmonUpdateParser.py -j | python broadcastServer.py
```

* open another terminal/bash and re-run step 1 in it. _Note_: check the
directory you are in, to create the python env you must be in
`<repo-root>/src/python`. Afterwards:
```
$ cd www
$ python server.py -h <IP address> -p <port>
```

* Default IP is `127.0.0.1` (localhost) with port `8000`. _Note_: you must also
replace `<IP address>` for the websocket in `src/html/monitoring.html`,
otherwise the bgp update will not work!

* Check if everything is up and running, go to:
```
http://<IP address>:<port>/hijack.html
http://<IP address>:<port>/monitoring.html
```
