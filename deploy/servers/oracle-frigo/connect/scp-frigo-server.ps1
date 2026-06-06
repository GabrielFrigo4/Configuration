### ================================
### Requires: Vault/servers.env loaded (FRIGO_IP variable)
### ================================
scp -r -i "${HOME}/.key/ssh-key-frigo-server.key" "$($args[0])" "ubuntu@${FRIGO_IP}:/home/ubuntu/$($args[0])"