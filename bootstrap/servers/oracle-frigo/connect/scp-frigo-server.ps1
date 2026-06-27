scp -r -i "${FRIGO_SERVER_KEY}" "$($args[0])" "ubuntu@${FRIGO_SERVER_IP}:/home/ubuntu/$($args[0])"
