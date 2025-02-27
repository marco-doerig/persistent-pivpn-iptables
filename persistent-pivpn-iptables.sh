#!/bin/bash

# Corresponding parts taken from the following script:
# https://github.com/pivpn/pivpn/blob/master/scripts/self_check.sh

VPN="wireguard"
setupVars="/etc/pivpn/${VPN}/setupVars.conf"

if [[ ! -f "${setupVars}" ]]; then
  err "::: Missing setup vars file!"
  exit 1
fi
source "${setupVars}"

echo "iptables -t nat -C POSTROUTING -s ${pivpnNET}/${subnetClass} -o ${IPv4dev} -j MASQUERADE -m comment --comment ${VPN}-nat-rule"
if iptables -t nat -C POSTROUTING -s "${pivpnNET}/${subnetClass}" -o "${IPv4dev}" -j MASQUERADE -m comment --comment "${VPN}-nat-rule" &> /dev/null; then
  echo ":: [OK] Iptables MASQUERADE rule already set"
else
  iptables -t nat -I POSTROUTING -s "${pivpnNET}/${subnetClass}" -o "${IPv4dev}" -j MASQUERADE -m comment --comment "${VPN}-nat-rule"
  iptables-save > /etc/iptables/rules.v4
  echo ":: [OK] Iptables MASQUERADE rule added"
fi

if iptables -C INPUT -i "${IPv4dev}" -p "${pivpnPROTO}" --dport "${pivpnPORT}" -j ACCEPT -m comment --comment "${VPN}-input-rule" &> /dev/null; then
  echo ":: [OK] Iptables INPUT rule already set"
else
  iptables -I INPUT 1 -i "${IPv4dev}" -p "${pivpnPROTO}" --dport "${pivpnPORT}" -j ACCEPT -m comment --comment "${VPN}-input-rule"
  iptables-save > /etc/iptables/rules.v4
  echo ":: [OK] Iptables INPUT rule added"
fi

if iptables -C FORWARD -s "${pivpnNET}/${subnetClass}" -i "${pivpnDEV}" -o "${IPv4dev}" -j ACCEPT -m comment --comment "${VPN}-forward-rule" &> /dev/null; t>  echo ":: [OK] Iptables FORWARD rule already set"
else
  iptables -I FORWARD 1 -d "${pivpnNET}/${subnetClass}" -i "${IPv4dev}" -o "${pivpnDEV}" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --c>  iptables -I FORWARD 2 -s "${pivpnNET}/${subnetClass}" -i "${pivpnDEV}" -o "${IPv4dev}" -j ACCEPT -m comment --comment "${VPN}-forward-rule"
  iptables-save > /etc/iptables/rules.v4
  echo ":: [OK] Iptables FORWARD rule added"
fi
