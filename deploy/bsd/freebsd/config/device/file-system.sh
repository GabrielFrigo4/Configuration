#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
    printf "Erro: Execute como root.\n"
    exit 1
fi

# Enable FUSE
sudo kldload fusefs
sudo sysrc kld_list+=" /boot/kernel/fusefs.ko"

# Enable EXT2+
sudo kldload ext2fs
sudo sysrc kld_list+=" /boot/kernel/ext2fs.ko"
