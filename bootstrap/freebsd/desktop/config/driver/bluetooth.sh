#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root."
	exit 1
fi

# Install Driver
sudo pkg install rtlbt-firmware
