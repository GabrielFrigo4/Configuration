#!/bin/sh

### ################################################################################################################################

### ################################
### Setup System (Root)
### ################################

# GROUPS
pw groupmod wheel -m "$(id -un)"

# PACKAGE
pkg bootstrap --yes
pkg update
pkg upgrade --yes

# SUDO
pkg install --yes sudo
cat << 'EOF' | tee "/usr/local/etc/sudoers.d/wheel" > "/dev/null"
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF
chmod 0440 "/usr/local/etc/sudoers.d/wheel"

# DOAS
pkg install --yes doas
cat << 'EOF' | tee "/usr/local/etc/doas.conf" > "/dev/null"
permit nopass :wheel
EOF
chmod 0440 "/usr/local/etc/doas.conf"

### ################################
### Setup Workspace (User)
### ################################

# WORKSPACE
mkdir -p "${HOME}/Workspace"

### ################################################################################################################################

### ################################
### Setup Shell (User)
### ################################

# SHELL
sudo pkg install --yes bash
sudo pkg install --yes zsh

### ################################
### Setup Wget (User)
### ################################

# WGET
sudo pkg install --yes wget
sudo pkg install --yes wget2
sudo pkg install --yes curl

### ################################
### Setup Git (User)
### ################################

# GIT ECOSYSTEM
sudo pkg install --yes git
sudo pkg install --yes git-credential-oauth
sudo pkg install --yes gh

# GIT CONFIG
rm "${HOME}/.gitconfig"
git config --global credential.helper "!gh auth git-credential"
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "Gabriel Frigo"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

# GITHUB CONFIG
gh auth login
gh auth setup-git

### ################################
### Setup Ports (User)
### ################################

# PORTS
sudo git clone "https://git.FreeBSD.org/ports.git" "/usr/ports"

# UPDATE
cd "/usr/ports"
sudo git pull
cd "${HOME}"

### ################################################################################################################################

### ################################
### Config Shell (User)
### ################################

# Default Shell
sudo chsh -s "$(which sh)" "$(id -un)"
sudo chsh -s "$(which sh)" "root"

### ################################################################################################################################
