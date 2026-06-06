#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root."
	exit 1
fi

# Setup Target Packages
FIRMWARES="gpu-firmware-intel-kmod-alderlake gpu-firmware-intel-kmod-tigerlake wifi-firmware-rtw88-kmod-rtw8821c"

# Check Network Connection
echo "Testando conexão com a internet (sem 'dhclient re')..."
if ! ping -c 1 -q 8.8.8.8 > "/dev/null" 2>&1; then
	echo "Testando conexão com a internet (com 'dhclient re')..."
	dhclient re0
	if ! ping -c 1 -q 8.8.8.8 > "/dev/null" 2>&1; then
		echo "Erro: Sem conexão com a internet."
		exit 1
	fi
fi

# Bootstrap Package Manager
echo "Inicializando o gerenciador de pacotes (pkg)..."
pkg bootstrap --yes

# Update Repositories
echo "Atualizando catálogos do FreeBSD..."
pkg update

# Install Firmware Packages
echo "Instalando firmwares de vídeo e Wi-Fi..."
pkg install --yes ${FIRMWARES}

echo "Firmwares instalados com sucesso!"
