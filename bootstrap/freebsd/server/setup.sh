#!/bin/sh

### ################################################################################################################################

### ################################
### Setup System (Root)
### ################################

pw groupmod wheel -m "$(id -un)"

pkg bootstrap --yes
pkg update
pkg upgrade --yes

### ################################
### Setup KVM/QEMU (Root)
### ################################

pkg install --yes qemu-guest-agent
sysrc qemu_guest_agent_enable="YES"
sysrc qemu_guest_agent_flags="-d -m virtio-serial -p /dev/ttyV0.1"
service qemu-guest-agent start

sysrc allscreens_flags="-f spleen-16x32"

### ################################
### Setup Sudo (Root)
### ################################

pkg install --yes sudo
cat << 'EOF' | tee "/usr/local/etc/sudoers.d/wheel" > "/dev/null"
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF
chmod 0440 "/usr/local/etc/sudoers.d/wheel"

### ################################
### Setup Doas (Root)
### ################################

pkg install --yes doas
cat << 'EOF' | tee "/usr/local/etc/doas.conf" > "/dev/null"
permit nopass :wheel
EOF
chmod 0440 "/usr/local/etc/doas.conf"

### ################################
### Setup Environment (Root)
### ################################

sysctl kern.coredump=0
cat << 'EOF' | tee -a "/etc/sysctl.conf" > "/dev/null"
kern.coredump=0
EOF

### ################################################################################################################################

### ################################
### Setup Shell
### ################################

sudo pkg install --yes bash
sudo pkg install --yes zsh

### ################################
### Setup Wget
### ################################

sudo pkg install --yes wget
sudo pkg install --yes wget2
sudo pkg install --yes curl

### ################################
### Setup Git
### ################################

sudo pkg install --yes git
sudo pkg install --yes git-credential-oauth
sudo pkg install --yes gh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/../../common/git.sh"

### ################################
### Setup Ports
### ################################

sudo git clone "https://git.FreeBSD.org/ports.git" "/usr/ports"
sudo git -C "/usr/ports" pull

### ################################
### Setup Jails
### ################################

sudo sysrc jail_enable="YES"

### ################################
### Setup Containers
### ################################

sudo pkg install --yes bastille
sudo sysrc bastille_enable="YES"
sudo service bastille start

### ################################################################################################################################

### ################################
### Config Shell
### ################################

sudo chsh -s "$(which sh)" "$(id -un)"
sudo chsh -s "$(which sh)" "root"

### ################################################################################################################################

### ################################
### Installing Needed Tools
### ################################

sudo pkg install --yes mandoc

sudo pkg install --yes zip
sudo pkg install --yes unzip
sudo pkg install --yes 7-zip

sudo pkg install --yes gnupg
sudo pkg install --yes openssl
sudo pkg install --yes libressl

### ################################
### Installing Rust Tools
### ################################

sudo pkg install --yes eza
sudo pkg install --yes fd-find
sudo pkg install --yes bat
sudo pkg install --yes grex
sudo pkg install --yes ripgrep

### ################################
### Installing System Fetch
### ################################

sudo pkg install --yes fastfetch
sudo pkg install --yes pfetch-rs
sudo pkg install --yes cpufetch

### ################################
### Installing Web/Net Tools
### ################################

touch "${HOME}/.w3m/history"
sudo pkg install --yes w3m
sudo pkg install --yes lynx

sudo pkg install --yes netcat

### ################################################################################################################################

### ################################
### Installing Editor
### ################################

sudo pkg install --yes emacs-nox
sudo pkg install --yes neovim
sudo pkg install --yes vim
sudo pkg install --yes helix
sudo pkg install --yes micro
sudo pkg install --yes mg
sudo pkg install --yes nano

### ################################################################################################################################
