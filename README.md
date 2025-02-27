# persistent-pivpn-iptables
Add missing iptables rules after reboot for PiVPN

To address the issue of iptables rules not persisting across reboots (iptables-save does not work, but are still included in the script), this script was created. It adds the necessary entries on each startup, utilizing relevant sections from the pivpn repository's 'self_check.sh' script ([https://github.com/pivpn/pivpn/blob/master/scripts/self_check.sh](https://github.com/pivpn/pivpn/blob/master/scripts/self_check.sh)).

## Installation
Log in as root for the following instructions.

```sh
wget -q https://raw.githubusercontent.com/marco-doerig/persistent-pivpn-iptables/refs/heads/main/persistent-pivpn-iptables.sh
chmod +x persistent-pivpn-iptables.sh
```

Add the following line to the crontab:

```sh
@reboot /root/persistent-pivpn-iptables.sh
```
