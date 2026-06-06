#!/bin/sh

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root (sudo)."
	exit 1
fi

# Desmontando a Partição "/linux"
mount | grep ' /linux' | awk '{print $3}' | sort -r | xargs -I {} umount {} 2> "/dev/null" || true

# Removendo a Entrada do "/etc/fstab"
sed -i.bak '/\/linux/d' "/etc/fstab"

# Deletando a Pasta "/linux"
if [ -d "/linux" ]; then
	find "/linux" -depth -type d -exec rmdir {} \; 2>/dev/null
fi
