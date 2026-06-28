scp -r -i "${ORBS_SERVER_KEY}" "$($args[0])" "ubuntu@${ORBS_SERVER_IP}:/home/ubuntu/$($args[0])"
