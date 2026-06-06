$FREEBSD_IP = (((virsh --connect "qemu:///system" domifaddr FreeBSD) -match "ipv4").Trim() -split '\s+')[3].Split('/')[0]
scp -r $args[0] "freebsd@${FREEBSD_IP}:/home/freebsd/$($args[0])"
