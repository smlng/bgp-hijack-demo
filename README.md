# BGP Hijack Demonstrator

## system requirements

This demo is under development and testing on Debian 7 (wheezy, testing). 

We want to use latest software versions, i.e., of quagga bgpd, we switched from
Debian stable to testing. To do so, proceed as follows:

    # cp /etc/apt/sources.list{,.bak}
    # sed -i -e 's/ \(stable\|wheezy\)/ testing/ig' /etc/apt/sources.list
    # apt-get update
    # apt-get --download-only dist-upgrade
    # apt-get dist-upgrade

(thx to: [http://unix.stackexchange.com/questions/90389/how-to-upgrade-debian-stable-wheezy-to-testing-jessie])

## install packages and software

On Debian/Ubuntu the following packages can be installed via apt-get or aptitude
 - python-dev
 - python-pip
 - python-virtualenv
 - quagga
 - snmp
 - libxml2-dev

On other Linux Distros search for equivalents in its package-management.

If 'bgpmon' is required, its source code can be downloaded here:
 [http://bgpmon.netsec.colostate.edu/index.php/download]

Compile with './configure && make', optional 'sudo make install'.

## Python dependencies

We recommend using Python with virtualenv and pip, no need to mess up your
local Python environment. However, the demo depends on these packages:

 - bottle
 - pysnmp
 - twisted
 - autobahn

For ease of deployment we provide a 'requirements.txt' under 'src/python', run

    # pip install -r requirements.txt

## configure and setup

Using Debian quagga daemons are installed to '/usr/lib/quagga'; this directory
is not in PATH environment, so 'bgpd' is not found automatically.
