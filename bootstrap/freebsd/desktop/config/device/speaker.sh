#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	printf "Erro: Execute como root.\n"
	exit 1
fi

# Set Default Audio Unit
sysctl hw.snd.default_unit=0
if command grep -q "^hw.snd.default_unit=" "/etc/sysctl.conf"; then
	sed -i '' 's/^hw.snd.default_unit=.*/hw.snd.default_unit=0/' "/etc/sysctl.conf"
else
	echo "hw.snd.default_unit=0" >> "/etc/sysctl.conf"
fi

# Maximize Volume Levels
mixer -f "/dev/mixer0" vol=1.00 pcm=1.00

# Remap Speaker Pins
HINTS_FILE="/boot/device.hints"
HINT_STRING='hint.hdaa.0.nid44.config="as=1 seq=0"'

if ! command grep -qF "${HINT_STRING}" "${HINTS_FILE}"; then
	echo "${HINT_STRING}" >> "${HINTS_FILE}"
fi
