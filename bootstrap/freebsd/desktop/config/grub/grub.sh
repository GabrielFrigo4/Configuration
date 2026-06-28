#!/bin/sh

# Stop on Error
set -e

# Check Privileges
if [ "$(id -u)" != "0" ]; then
	echo "Erro: Execute como root (sudo)."
	exit 1
fi

# Setup Variables
GRUB_FILE="/etc/default/grub"
CUSTOM_GRUB_FILE="/etc/grub.d/40_custom"
FREEBSD_DEV="/dev/nvme0n1p3"

# Auto-detect FreeBSD EFI UUID
FREEBSD_UUID="$(blkid -s UUID -o value "${FREEBSD_DEV}")"

if [ -z "${FREEBSD_UUID}" ]; then
	echo "Erro: Não foi possível detectar o UUID em ${FREEBSD_DEV}."
	exit 1
fi

# Backup GRUB Configs
cp "${GRUB_FILE}" "${GRUB_FILE}.backup" || true
cp "${CUSTOM_GRUB_FILE}" "${CUSTOM_GRUB_FILE}.backup" || true
sudo chmod -x "${GRUB_FILE}.backup" || true
sudo chmod -x "${CUSTOM_GRUB_FILE}.backup" || true

# Show GRUB Menu (Muda de hidden para menu)
if grep -q "GRUB_TIMEOUT_STYLE=hidden" "${GRUB_FILE}"; then
	sed -i 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/' "${GRUB_FILE}"
fi

# Enable os-prober
if grep -q "GRUB_DISABLE_OS_PROBER" "${GRUB_FILE}"; then
	sed -i 's/.*GRUB_DISABLE_OS_PROBER.*/GRUB_DISABLE_OS_PROBER=false/' "${GRUB_FILE}"
else
	echo "GRUB_DISABLE_OS_PROBER=false" >> "${GRUB_FILE}"
fi

# Add or Update FreeBSD Entry
if ! grep -q "menuentry \"FreeBSD\"" "${CUSTOM_GRUB_FILE}"; then
	cat << EOF | tee -a "${CUSTOM_GRUB_FILE}" > "/dev/null"

menuentry "FreeBSD" --class freebsd --class os {
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root ${FREEBSD_UUID}
	chainloader /efi/boot/bootx64.efi
}
EOF
sudo chmod +x "${CUSTOM_GRUB_FILE}"
else
	sed -i "s/search --no-floppy --fs-uuid --set=root .*/search --no-floppy --fs-uuid --set=root ${FREEBSD_UUID}/" "${CUSTOM_GRUB_FILE}"
fi

# Update GRUB
update-grub
