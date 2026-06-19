### ================================
### Requires: Vault/servers.env loaded (ORBS_IP variable)
### ================================
scp -r -i "${HOME}/.key/ssh-key-orbs-server.key" "$($args[0])" "ubuntu@${ORBS_SERVER_IP}:/home/ubuntu/$($args[0])"