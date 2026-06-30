@echo off
ssh -i "%HOME%\.key\ssh-key-frigo-server.key" "ubuntu@%FRIGO_SERVER_IP%"
