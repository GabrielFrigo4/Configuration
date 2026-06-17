#!/usr/bin/env sh
### ================================
### Requires: Vault/servers.env loaded (ORBS_SERVER_IP variable)
### ================================
ssh -i "${HOME}/.key/ssh-key-orbs-server.key" "ubuntu@${ORBS_SERVER_IP}"
