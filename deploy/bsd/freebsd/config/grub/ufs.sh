#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root (sudo)."
	exit 1
fi

# Setup Target Configuration
DISK="nvme0n1"
MNT_DIR="/mnt"

# Mount EFI Partition
mount "/dev/${DISK}p3" "${MNT_DIR}"

# Create Directory
mkdir -p "${MNT_DIR}/efi/freebsd"

# Setup Loader Environment
cat << 'EOF' > "${MNT_DIR}/efi/freebsd/loader.env"
rootdev=disk0p4:
currdev=disk0p4:
EOF

# Unmount EFI Partition
umount "${MNT_DIR}"
