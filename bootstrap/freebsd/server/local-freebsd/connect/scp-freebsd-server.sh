#!/bin/sh
FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr FreeBSD | awk '$(3) == "ipv4" {print $(4)}' | cut -d'/' -f1)"
scp -r "${1}" "freebsd@${FREEBSD_IP}:/home/freebsd/${1}"
