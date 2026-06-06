#!/usr/bin/env sh
### ================================
### Requires: Vault/servers.env loaded (FRIGO_IP variable)
### ================================
scp -r -i "${HOME}/.key/ssh-key-frigo-server.key" "${1}" "ubuntu@${FRIGO_IP}:/home/ubuntu/${1}"
