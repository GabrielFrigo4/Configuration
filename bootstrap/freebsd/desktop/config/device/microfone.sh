#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	printf "Erro: Execute como root.\n"
	exit 1
fi

# Set Default Audio Unit
sysctl hw.snd.default_unit=1
if command grep -q "^hw.snd.default_unit=" "/etc/sysctl.conf"; then
	sed -i '' 's/^hw.snd.default_unit=.*/hw.snd.default_unit=1/' "/etc/sysctl.conf"
else
	echo "hw.snd.default_unit=1" >> "/etc/sysctl.conf"
fi

# Maximize Volume Levels
mixer -f "/dev/mixer0" mic=1.00 || true
mixer -f "/dev/mixer1" rec=1.00 || true
mixer -f "/dev/mixer1" monitor=1.00 || true
