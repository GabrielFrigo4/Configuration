@echo off
rem ================================
rem Requires: Vault/servers.env loaded (FRIGO_IP variable)
rem ================================
ssh -i "%HOME%\.key\ssh-key-frigo-server.key" "ubuntu@%FRIGO_IP%"
