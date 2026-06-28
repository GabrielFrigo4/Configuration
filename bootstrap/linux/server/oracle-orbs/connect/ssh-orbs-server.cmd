@echo off
rem ================================
rem Requires: Vault/servers.env loaded (ORBS_SERVER_IP variable)
rem ================================
ssh -i "%HOME%\.key\ssh-key-orbs-server.key" "ubuntu@%ORBS_SERVER_IP%"
