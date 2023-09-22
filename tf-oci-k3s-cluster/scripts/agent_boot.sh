#!/bin/bash -xe

ufw disable

iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited || true
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited || true
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 6443 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 6443 -j ACCEPT
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" K3S_URL="https://${server_ip}:6443" K3S_TOKEN="${token}" sh -
