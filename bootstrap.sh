#!/usr/bin/env bash

SSHOpts=("UsePAM" "UseDNS" "X11Forwarding" "PasswordAuthentication" "PermitRootLogin")

for opt in "${SSHOpts[@]}"; do
	sed -i "s/^#*$opt *[-A-Za-z0-9]*/$opt no/" /etc/ssh/sshd_config
done

apt update -y && apt upgrade -y
apt install -y git tmux htop

read -p "New user (blank to skip): "
if [[ -n "$REPLY" ]]; then
	useradd -G mail,sudo -m -s /bin/bash "$REPLY"
	passwd "$REPLY"
fi

systemctl reload sshd
