#!/usr/bin/sh

### ################################
### Installing Postgres
### ################################

yay --needed --noconfirm -S postgresql

sudo -u postgres -i
initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'
exit

sudo systemctl enable --now postgresql
sudo systemctl status postgresql

psql -U postgres
\password
