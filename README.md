# BGP Hijack Demonstrator -- README

## system requirements

This demo is under development and testing on Debian 7 (wheezy, testing). 

We want to use latest software versions, i.e., of quagga bgpd, we switched from
Debian stable to testing. To do so, proceed as follows:

    # cp /etc/apt/sources.list{,.bak}
    # sed -i -e 's/ \(stable\|wheezy\)/ testing/ig' /etc/apt/sources.list
    # apt-get update
    # apt-get --download-only dist-upgrade
    # apt-get dist-upgrade

see [here](http://unix.stackexchange.com/questions/90389/how-to-upgrade-debian-stable-wheezy-to-testing-jessie)
for details and the original post.

## install packages and software

On Debian/Ubuntu the following packages can be installed via apt-get or aptitude:

 - libxml2-dev
 - openvpn
 - python-dev
 - python-pip
 - python-virtualenv
 - quagga
 - snmp
 - snmpd

On other Linux Distros search for equivalents in its package-management.

If 'bgpmon' is required, its source code can be downloaded 
[here](http://bgpmon.netsec.colostate.edu/index.php/download).

Compile with `./configure && make`, optional `sudo make install`.

## python dependencies

We recommend using Python with virtualenv and pip, no need to mess up your
local Python environment. However, the demo depends on these packages:

 - bottle
 - pysnmp
 - twisted
 - autobahn

For ease of deployment we provide a `requirements.txt` under `src/python`, run

    # cd src/python
    # virtualenv .
    # source bin/activate
    # pip install -r requirements.txt

## further notes

Using Debian, the quagga daemons are installed to `/usr/lib/quagga`; this directory
is not in PATH environment, so `bgpd` is not found automatically.

The binray of BGPmon will be installed to `/usr/local/bin/bgpmon` by default, which
typically is within the PATH environment variable.

More information and details on the demo setup can be found in the `SETUP.md`.