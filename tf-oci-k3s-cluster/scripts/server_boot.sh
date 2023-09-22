#!/bin/bash -xe

ufw disable

iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited || true
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited || true
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 6443 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 6443 -j ACCEPT
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -C INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT || iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --tls-san ${domain}" K3S_TOKEN="${token}" K3S_KUBECONFIG_MODE="0644" K3S_CLUSTER_INIT="true" sh -
