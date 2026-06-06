#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
    printf "Erro: Execute como root.\n"
    exit 1
fi

# Install Firmware Package
pkg install --yes rtlbt-firmware

# Create Firmware Link Files
sudo mkdir -p /usr/share/firmware
sudo ln -s /usr/local/share/rtlbt-firmware /usr/share/firmware/rtlbt

# Load Bluetooth Module
kldload -n ng_ubt || true

# Enable Bluetooth Service
sysrc bluetooth_enable="YES"

# Inject Hardware Firmware
rtlbtfw -d ugen0.6 -f "/usr/local/share/rtlbt-firmware" || true

# Restart Bluetooth Interface
service bluetooth restart ubt0 || true

# Verify Radio Status
hccontrol -n ubt0hci read_local_name || true
