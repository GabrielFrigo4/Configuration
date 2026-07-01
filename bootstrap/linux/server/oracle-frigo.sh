#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup APT
### ################################

sudo apt update
sudo apt upgrade -y

### ################################
### Setup Swap
### ################################

sudo fallocate -l 2G "/swap"
sudo chmod 0600 "/swap"
sudo mkswap "/swap"
sudo swapon "/swap"
echo "/swap none swap sw 0 0" | sudo tee -a "/etc/fstab" > "/dev/null"

sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a "/etc/sysctl.conf"

### ################################################################################################################################

### ################################
### Setup Table TCP/IPv6
### ################################

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT

### ################################
### Setup Table TCP/IPv4
### ################################

sudo ip6tables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
sudo ip6tables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo ip6tables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

### ################################
### Setup Table Host
### ################################

cat << 'EOF' | sudo tee -a "/etc/hosts" > "/dev/null"
EOF

### ################################
### Installing Container Essential
### ################################

sudo apt install --yes podman
sudo apt install --yes docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$(id -un)"
sudo loginctl enable-linger "$(id -un)"

### ################################
### Setup Proxy Caddy
### ################################

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

cat << 'EOF' | sudo tee  "/etc/caddy/Caddyfile" > "/dev/null"
gabrielfrigo.dev.br, www.gabrielfrigo.dev.br, resume.gabrielfrigo.dev.br {
	reverse_proxy [::1]:35440
}
game.gabrielfrigo.dev.br {
	reverse_proxy [::1]:35441
}
EOF

sudo systemctl restart caddy

### ################################
### Setup Resume Server
### ################################

cat << 'EOF' | sudo tee "/home/ubuntu/resume/.env" > "/dev/null"
EOF

cat << 'EOF' | sudo tee "/etc/systemd/system/resume.service" > "/dev/null"
[Unit]
Description=Gabriel Frigo - Resume
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/resume/
EnvironmentFile=/home/ubuntu/game/.env
ExecStart=/home/ubuntu/resume/resume
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now resume

sudo systemctl daemon-reload
sudo systemctl restart resume

### ################################
### Setup Game Server
### ################################

cat << 'EOF' | sudo tee "/home/ubuntu/game/.env" > "/dev/null"
ADMIN_USER=Gerbunte
ADMIN_PASS=CacarumbaZ
EOF

cat << 'EOF' | sudo tee "/etc/systemd/system/game.service" > "/dev/null"
[Unit]
Description=Gabriel Frigo - Game
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/game/
EnvironmentFile=/home/ubuntu/game/.env
ExecStart=/home/ubuntu/game/game
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now game

sudo systemctl daemon-reload
sudo systemctl restart game

### ################################################################################################################################

### ################################
### Update and Upgrade System
### ################################

sudo apt update
sudo apt upgrade --yes

### ################################
### Setup System
### ################################

sudo apt install --yes doas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit nopass :sudo
EOF
sudo chmod 0440 "/etc/doas.conf"

### ################################
### Installing Internet Essential
### ################################

sudo apt install --yes iptables-persistent
sudo netfilter-persistent save

### ################################
### Installing Git Ecosystem
### ################################

sudo apt install --yes git
sudo apt install --yes git-credential-oauth
sudo apt install --yes gh

### ################################
### Installing Git Credential Manager
### ################################

GCM_VER="$(curl -Ls -o "/dev/null" -w %{url_effective} "https://github.com/git-ecosystem/git-credential-manager/releases/latest" | awk -F/ '{print $(NF)}' | sed 's/^v//')"
wget -O gcm.deb "https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VER}/gcm-linux-x64-${GCM_VER}.deb"
sudo apt install --yes "./gcm.deb"
rm "./gcm.deb"

### ################################
### Setup Git Config
### ################################

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/../../common/git.sh"

### ################################################################################################################################

### ################################
### Setup Terminal Editors
### ################################

sudo apt install --yes mg
sudo apt install --yes micro
sudo apt install --yes vim

### ################################
### Setup Editor Configs
### ################################

. "${SCRIPT_DIR}/../../common/editors.sh"

### ################################
### Installing Bash
### ################################

sudo apt install --yes bash

### ################################
### Installing Zsh
### ################################

sudo apt install --yes zsh
sudo chsh -s "$(which zsh)" "$(id -un)"
sudo chsh -s "$(which zsh)" "root"

### ################################################################################################################################
