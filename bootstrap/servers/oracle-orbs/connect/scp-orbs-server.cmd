@echo off
rem ================================
rem Requires: Vault/servers.env loaded (ORBS_IP variable)
rem ================================
scp -r -i "%HOME%/.key/ssh-key-orbs-server.key" "%1" "ubuntu@%ORBS_IP%:/home/ubuntu/%1"
