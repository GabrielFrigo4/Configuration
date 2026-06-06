@echo off
rem ================================
rem Requires: Vault/servers.env loaded (FRIGO_IP variable)
rem ================================
scp -r -i "%HOME%/.key/ssh-key-frigo-server.key" "%1" "ubuntu@%FRIGO_IP%:/home/ubuntu/%1"
