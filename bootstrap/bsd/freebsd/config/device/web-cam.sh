#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root."
	exit 1
fi

# Enable Webcamd Service
sysrc webcamd_enable="YES"

# Persist Cuse Module
sysrc kld_list+=" /boot/kernel/cuse.ko"

# Load Cuse Module
kldload -n cuse || true

# Start Webcamd Service
service webcamd start || true
