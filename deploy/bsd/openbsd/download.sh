#!/bin/sh

# Stop on Error
set -e

# Environment OpenBSD
OPENBSD_URL="https://cdn.openbsd.org/pub/OpenBSD"
OPENBSD_VER="$(curl -sL "${OPENBSD_URL}/" | sed -n 's/.*href="\([0-9]\+\.[0-9]\+\)\/".*/\1/p' | sort -V | tail -n 1)"
OPENBSD_NUM="$(echo "${OPENBSD_VER}" | tr -d '.')"
ISO_NAME="install${OPENBSD_NUM}.iso"

# Download OpenBSD
curl -o "OpenBSD.iso" "${OPENBSD_URL}/${OPENBSD_VER}/amd64/${ISO_NAME}"

# Verify Checksum
curl -sL "${OPENBSD_URL}/${OPENBSD_VER}/amd64/SHA256" | \
	grep "(${ISO_NAME})" | awk '{print $(4) " *OpenBSD.iso"}' | sha256sum -c -
