# RPKI verification - demo extension

## Introduction

This demo extensions shows how end-users can detect BGP hijacks using a Firefox
browser addon. The addon verifies the BGP origin AS of a webserver responsible
for a certain URL. In our demo we can hijack prefixes of different demo ASes,
e.g., the prefix associated with the webserver of the newspaper 'Zeit'. To show
the effect of such a hijack without manipulating real BGP data, we use a
modified version of the RPKI validator addon for Firefox. This modified addon
works for the URL 'zeit.de' only.

Edit `/etc/hosts` and point `zeit.de` to the IP address of the primary network
interface (e.g. `eth0`). For example, if IP is `192.168.0.100`, add:
```
192.168.0.100 zeit.de demo.zeit.de
```

In some cases DNS entries are cached and `zeit.de` will still refer to the
original server. In that case use `demo.zeit.de` as the URL for the demo.

Further, it may help or resolv some issues using Firefox in private mode and
when reloading the website use key-shortcut `strg+shift+r` to force reload,
otherwise Firefox might show a cached page.

However, during initial setup follow the next steps to install and setups the
RPKI Firefox addon as well as the nginx webserver.

## RPKI Firefox addon

Install the Firefox browser, download [here](http://www.mozilla.org/firefox) and
afterwards start Firefox and goto menu->AddOns. Install the RPKI plugin manually
from file using `<path/to/repo>/rpki/firefox-addon/rpki-validator.xpi`.

_Note_: The official and working RPKI Firefox addon can be found [here](https://github.com/rtrlib/firefox-addon).
For productional usage install it via the Firefox Addon store, search for
`rpki validator`. The demo addon is modified and might be outdated.

## Nginx webserver setup

Assuming the Nginx webserver is installed, there should exist a config directory
`/etc/nginx/`. Then, copy config file and content as follows:
```
# sudo cp <path/to/repo>/etc/nginx/zeitde.conf /etc/nginx/conf.d/.
# sudo cp -rp <path/to/repo>/var/www/zeit.de/ /var/www/.
```

Reboot system or restart `nginx` by running:
```
$ sudo systemctl restart nginx
```
