#!/usr/bin/env sh
### ================================
### Requires: Vault/servers.env loaded (ORBS_IP variable)
### ================================
scp -r -i "${HOME}/.key/ssh-key-orbs-server.key" "${1}" "ubuntu@${ORBS_IP}:/home/ubuntu/${1}"
