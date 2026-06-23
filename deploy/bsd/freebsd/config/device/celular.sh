#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
    printf "Erro: Execute como root.\n"
    exit 1
fi

# Enable CellOut
pulseaudio --start
pactl load-module module-null-sink sink_name=CelOut
pactl load-module module-simple-protocol-tcp rate=44100 format=s16le channels=2 source=CelOut.monitor record=true port=8000 listen=0.0.0.0

# Enable CellIn


# Get Internet Protocol (IP)
ifconfig
