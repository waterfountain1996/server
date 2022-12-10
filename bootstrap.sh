#!/usr/bin/env bash

SSHOpts=("UsePAM" "X11Forwarding" "PasswordAuthentication" "PermitRootLogin")

for opt in "${SSHOpts[@]}"; do
	sed -i "s/^#*$opt *[-A-Za-z0-9]*/$opt no/" /etc/ssh/sshd_config
done

apt update -y && apt upgrade -y

read -p "New user (blank to skip): "
if [[ -n "$REPLY" ]]; then
	useradd -G mail,sudo -m "$REPLY"
	passwd "$REPLY"
	if [[ $? -ne 0 ]]; then
		printf "Failed to set password, deleting user %s\n" "$REPLY"
		userdel -r "$REPLY"
	fi
	chsh "$REPLY" -s /bin/bash
fi

systemctl reload sshd
