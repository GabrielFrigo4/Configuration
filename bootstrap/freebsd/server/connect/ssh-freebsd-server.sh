#!/bin/sh
FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr FreeBSD | awk '$(3) == "ipv4" {print $(4)}' | cut -d'/' -f1)"
ssh "freebsd@${FREEBSD_IP}"
