@echo off
scp -r -i "%FRIGO_SERVER_KEY%" "%1" "ubuntu@%FRIGO_SERVER_IP%:/home/ubuntu/%1"
