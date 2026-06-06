#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root."
	exit 1
fi

# Setup Target Configuration
WLAN_DEV="rtw880"
WLAN_INT="wlan0"

# Configure rc.conf
sysrc wlans_${WLAN_DEV}="${WLAN_INT}"
sysrc ifconfig_${WLAN_INT}="WPA DHCP"
sysrc background_dhclient="YES"

# Setup WPA Supplicant
cat << 'EOF' | tee "/etc/wpa_supplicant.conf" > "/dev/null"
network={
	ssid="LeT Local"
	psk="84658465Net"
}

network={
	ssid="GabrielF"
	psk="Escoteiro12"
}
EOF

# Set Permissions
chmod 0600 "/etc/wpa_supplicant.conf"

# Start Wireless
service netif restart
