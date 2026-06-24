@echo off
rem ================================
rem Requires: Vault/servers.env loaded (FRIGO_SERVER_IP variable)
rem ================================
ssh -i "%HOME%\.key\ssh-key-frigo-server.key" "ubuntu@%FRIGO_SERVER_IP%"
