@echo off
scp -r -i "%ORBS_SERVER_KEY%" "%1" "ubuntu@%ORBS_SERVER_IP%:/home/ubuntu/%1"
