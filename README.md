# BGP Hijack Demonstrator - README

## system requirements

This software is under development and testing on Linux Debian 8 (Jessie).

## install packages and software

On Debian the following packages can be installed via apt-get or aptitude:

 - libxml2-dev,         needed by python for xml parsing and bgpmon
 - openvpn,             to create tap tunnel devices
 - python-dev,          needed to build and install python libraries via pip
 - python-pip,          a package manager for python
 - python-virtualenv,   run python code in a change-root like environment
 - quagga,              BGP daemon
 - snmp,                SNMP client stuff
 - snmpd,               SNMP server stuff

additional, but optional:
 - nginx,               a light webserver to demonstrate RPKI verification
 - screen,              terminal/shell multiplexer
 - vim,                 the editor

Install shutcut:

    # apt-get install libxml2-dev openvpn python-dev python-pip python-virtualenv quagga snmp snmpd
    # apt-get install nginx screen vim

On other Linux Distros search for equivalents in their package-management.

At the moment `bgpmon` cannot be found in standard package repos. So you
need to compile and install it from scratch. Its source code can be downloaded
[here](http://www.bgpmon.io/download.html).

Compile with `./configure && make`, optional `sudo make install`.

_Note_: there is bug in bgpmon-7.4 causing segfaults when connecting to multiple
bgp peers, but luckily we provide a patch for that. Apply the patch as follows:

    $ cd /path/to/bgpmon-7.4-source
    $ patch -p1 < /path/to/bgp-hijack-demo/src/bgpmon/createSessionStruct.patch
    $ ./configure
    $ make
    $ sudo make install

## python dependencies

We recommend using Python with virtualenv and pip, no need to mess up your
local Python environment. However, the demo depends on these packages:

 - bottle
 - pysnmp
 - twisted
 - autobahn

For ease of deployment we provide a `requirements.txt` under `src/python`, run

    $ cd src/python
    $ virtualenv .
    $ source bin/activate
    $ pip install -r requirements.txt

## further notes

Using Debian, the quagga daemons are installed to `/usr/lib/quagga`; this
directory is not in `PATH` environment, so `bgpd` is not found automatically.

The binary of BGPmon will be installed to `/usr/local/bin/bgpmon` by default,
which typically is within the PATH environment variable.

More information and details on the demo setup can be found in the [SETUP.md](SETUP.md).
