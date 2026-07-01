#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup System
### ################################

usermod -aG sudo gabriel

sudo sed -i 's/main non-free-firmware/main non-free-firmware contrib non-free/' /etc/apt/sources.list

sudo apt update
sudo apt upgrade -y

sudo apt install --yes manpages
sudo apt install --yes man-db

### ################################
### Installing Graphics Drivers
### ################################

sudo apt install --yes libgl1-mesa-dev
sudo apt install --yes libglu1-mesa-dev
sudo apt install --yes mesa-common-dev
sudo apt install --yes mesa-utils

### ################################
### Installing NVIDIA Drivers
### ################################

sudo apt install --yes nvidia-driver
sudo apt install --yes firmware-misc-nonfree

### ################################
### Installing Prerequisites
### ################################

sudo apt install --yes gnupg
sudo apt install --yes software-properties-common
sudo apt install --yes apt-transport-https
sudo apt install --yes ca-certificates

### ################################
### Setup DOAS
### ################################

sudo apt install --yes doas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit persist :sudo
EOF
sudo chmod 0440 "/etc/doas.conf"

### ################################################################################################################################

### ################################
### Setup Init
### ################################

cat << 'EOF' | tee "${HOME}/init" > "/dev/null"
#!/usr/bin/bash

emacs --fg-daemon &

disown
EOF
chmod +x "${HOME}/init"

mkdir -p "${HOME}/.config/autostart"
cat << 'EOF' | tee "${HOME}/.config/autostart/init.desktop" > "/dev/null"
[Desktop Entry]
Type=Application
Name=Init Shell Script
Exec=/home/gabriel/init
Icon=utilities-terminal
Comment=Executa um Script Shell Init
X-GNOME-Autostart-enabled=true
EOF

### ################################
### Setup Templates
### ################################

touch "${HOME}/Modelos/blank"
touch "${HOME}/Modelos/text.txt"
touch "${HOME}/Modelos/markdown.md"
touch "${HOME}/Modelos/orgmode.org"
cat << 'EOF' | "${HOME}/Modelos/shell.sh" > "/dev/null"
#!/usr/bin/bash

EOF

### ################################
### Setup Workspace
### ################################

mkdir -p "${HOME}/Workspace"

cat << 'EOF' | tee "${HOME}/.local/bin/firefox-nvc" > "/dev/null"
#!/usr/bin/bash
DRI_PRIME=1 /usr/bin/firefox "$@"
EOF
chmod +x "${HOME}/.local/bin/firefox-nvc"

### ################################################################################################################################

### ################################
### Installing Packages
### ################################

sudo apt install --yes flatpak
sudo apt install --yes gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
alias flatall="flatpak override --user --filesystem=host --share=ipc --share=network --socket=system-bus --socket=session-bus --device=all --talk-name=org.freedesktop.Flatpak"

sudo apt install --yes gnome-themes-extra

sudo apt install --yes musl
sudo apt install --yes musl-dev
sudo apt install --yes musl-tools

sudo apt install --yes binutils
sudo apt install --yes coreutils

sudo apt install --yes unzip
sudo apt install --yes zip
sudo apt install --yes tar

sudo apt install --yes wget
sudo apt install --yes wget2
sudo apt install --yes curl

### ################################
### Setup Git
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
. "${SCRIPT_DIR}/../../../common/git.sh"

### ################################
### Setup LXC
### ################################

sudo apt install --yes lxc
sudo apt install --yes lxc-templates
sudo systemctl enable --now lxc-net
sudo systemctl enable --now lxc

sudo apt install --yes incus
sudo systemctl enable --now incus.socket
sudo usermod -aG incus-admin "$(id -un)"
newgrp incus-admin

cat << 'EOF' | sudo tee -a "/etc/subuid" > "/dev/null"
root:100000:65536
EOF
cat << 'EOF' | sudo tee -a "/etc/subgid" > "/dev/null"
root:100000:65536
EOF
sudo systemctl restart incus

### ################################################################################################################################

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

### ################################
### Installing Nushell
### ################################

curl -fsSL "https://apt.fury.io/nushell/gpg.key" | sudo gpg --dearmor -o "/etc/apt/trusted.gpg.d/fury-nushell.gpg"
echo "deb https://apt.fury.io/nushell/ /" | sudo tee "/etc/apt/sources.list.d/fury.list" > "/dev/null"
sudo apt update
sudo apt install --yes nushell

curl -sL "https://ohmyposh.dev/install.sh" | bash -s
mkdir "${HOME}/.oh-my-posh"
wget "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -O "${HOME}/.oh-my-posh/themes.zip"
unzip "${HOME}/.oh-my-posh/themes.zip" -d "${HOME}/.oh-my-posh"
chmod u+rw ~/.oh-my-posh/*.json
rm "${HOME}/.oh-my-posh/themes.zip"
oh-my-posh init nu --config "${HOME}/.oh-my-posh/atomic.omp.json" > "${HOME}/.oh-my-posh.nu"

cat << 'EOF' | tee -a "${HOME}/.config/nushell/config.nu" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

### ################################
### SHELL OH-MY-POSH
### ################################

source "~/.oh-my-posh.nu";

### ################################
### SHELL ALIAS
### ################################

### ################################
### SHELL FUNCTIONS
### ################################

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################################################################################################################

### ################################
### Installing System Fonts
### ################################

sudo apt install --yes fontconfig
mkdir -p "${HOME}/.local/share/fonts"

### ################################
### Microsoft System Fonts
### ################################

sudo apt install --yes ttf-mscorefonts-installer
sudo apt install --yes fonts-crosextra-carlito

### ################################
### Nerd Fonts
### ################################

. "${SCRIPT_DIR}/../../../common/fonts.sh"

### ################################################################################################################################

### ################################
### Installing System Tools
### ################################

sudo apt install --yes universal-ctags
sudo apt install --yes wl-clipboard
sudo apt install --yes xclip xsel

### ################################
### Installing Container Tools
### ################################

sudo apt install --yes podman

sudo apt install --yes docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$(id -un)"

### ################################
### Installing Web/Net Tools
### ################################

sudo apt install --yes network-manager-openvpn-gnome
sudo apt install --yes network-manager-openvpn
sudo apt install --yes openvpn

touch "${HOME}/.w3m/history"
sudo apt install --yes elinks w3m lynx

### ################################
### Installing Wine Tools
### ################################

sudo apt install --yes wine

### ################################################################################################################################

### ################################
### Installing Window Editors
### ################################

flatpak install -y flathub com.visualstudio.code
flatall com.visualstudio.code
cat << 'EOF' | tee "${HOME}/.local/bin/code" > "/dev/null"
#!/usr/bin/bash
flatpak run com.visualstudio.code "$@"
EOF
chmod +x "${HOME}/.local/bin/code"
cat << 'EOF' | tee "${HOME}/.local/bin/code-nvc" > "/dev/null"
#!/usr/bin/bash
DRI_PRIME=1 ${HOME}/.local/bin/code "$@"
EOF
chmod +x "${HOME}/.local/bin/code-nvc"

curl -f https://zed.dev/install.sh | bash
cat << 'EOF' | tee "${HOME}/.local/bin/zed-nvc" > "/dev/null"
#!/usr/bin/bash
DRI_PRIME=1 ${HOME}/.local/bin/zed "$@"
EOF
chmod +x "${HOME}/.local/bin/zed-nvc"

sudo apt install --yes geany
cat << 'EOF' | tee "${HOME}/.local/bin/geany" > "/dev/null"
#!/usr/bin/bash
GTK_THEME=Adwaita:dark /usr/bin/geany "$@"
EOF
chmod +x "${HOME}/.local/bin/geany"

sudo mkdir -p "/etc/apt/keyrings"
curl -fsSL "https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg" | \
sudo gpg --dearmor --yes -o "/etc/apt/keyrings/antigravity-repo-key.gpg"
cat << 'EOF' | sudo tee "/etc/apt/sources.list.d/antigravity.list" > "/dev/null"
deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main
EOF
sudo apt update
sudo apt install --yes antigravity

cat << 'EOF' | sudo tee "/usr/bin/ant" > "/dev/null"
#!/usr/bin/sh
antigravity "$@"
EOF
sudo chmod +x "/usr/bin/ant"

### ################################
### Installing Terminal Editors
### ################################

sudo apt install --yes mg
sudo apt install --yes micro
sudo apt install --yes hx
sudo apt install --yes neovim
sudo apt install --yes vim
sudo apt install --yes emacs

### ################################
### Setup Helix Wrapper
### ################################

cat << 'EOF' | tee "${HOME}/.local/bin/hx" > "/dev/null"
#!/usr/bin/bash
/usr/bin/hx "$@"
echo -e -n "\x1b[\x30 q"
EOF
chmod +x "${HOME}/.local/bin/hx"

### ################################
### Setup Editor Configs
### ################################

. "${SCRIPT_DIR}/../../../common/editors.sh"

### ################################################################################################################################

### ################################
### Installing Rust CLI Tools
### ################################

sudo apt install --yes eza
sudo apt install --yes bat
sudo apt install --yes fd-find
sudo apt install --yes ripgrep

### ################################
### Alias Rust Tools
### ################################

cat << 'EOF' | sudo tee "/usr/local/bin/bat" > "/dev/null"
#!/bin/bash
batcat "$@"
EOF
sudo chmod +x "/usr/local/bin/bat"

cat << 'EOF' | sudo tee "/usr/local/bin/fd" > "/dev/null"
#!/bin/bash
fdfind "$@"
EOF
sudo chmod +x "/usr/local/bin/fd"

### ################################
### Installing TeX / LaTeX
### ################################

sudo apt install --yes texlive-latex-extra
sudo apt install --yes texlive-lang-portuguese

### ################################
### Installing Pandoc Tools
### ################################

sudo apt install --yes pandoc
sudo apt install --yes weasyprint

### ################################
### Installing Media Tools
### ################################

sudo apt install --yes imagemagick
sudo apt install --yes ffmpeg

### ################################
### Installing System Fetch
### ################################

sudo apt install --yes fastfetch

### ################################
### Installing File Tools
### ################################

sudo apt install --yes dos2unix

### ################################
### Installing Security Tools
### ################################

sudo apt install --yes checksec
sudo apt install --yes dirb

### ################################
### Installing Firebase
### ################################

curl -sL "https://firebase.tools" | sudo upgrade=true bash

### ################################################################################################################################

### ################################
### Installing Network Analysis Tools
### ################################

sudo apt install --yes wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -aG wireshark "$(id -un)"
newgrp wireshark
cat << 'EOF' | sudo tee "/usr/local/bin/wireshark" > "/dev/null"
#!/bin/bash
QT_QPA_PLATFORMTHEME="" /usr/bin/wireshark "$@"
EOF
sudo chmod +x "/usr/local/bin/wireshark"

### ################################
### Installing Database Tools
### ################################

sudo wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee "/etc/apt/sources.list.d/dbeaver.list" > "/dev/null"
sudo apt update
sudo apt install --yes dbeaver-ce

### ################################
### Installing Web Browsers
### ################################

curl -fSsL "https://dl.google.com/linux/linux_signing_key.pub" | sudo gpg --dearmor | sudo tee "/usr/share/keyrings/google-chrome.gpg" > "/dev/null"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee "/etc/apt/sources.list.d/google-chrome.list"
sudo apt update
sudo apt install --yes google-chrome-stable

curl -fSsL "https://packages.microsoft.com/keys/microsoft.asc" | sudo gpg --dearmor | sudo tee "/usr/share/keyrings/microsoft-edge.gpg" > "/dev/null"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee "/etc/apt/sources.list.d/microsoft-edge.list"
sudo apt update
sudo apt install --yes microsoft-edge-stable

### ################################
### Installing Git GUI Tools
### ################################

flatpak install -y flathub io.github.shiftey.Desktop
flatall io.github.shiftey.Desktop

### ################################
### Installing Office Software
### ################################

flatpak install -y flathub org.onlyoffice.desktopeditors
flatall org.onlyoffice.desktopeditors

### ################################
### Installing pgAdmin
### ################################

flatpak install -y flathub org.pgadmin.pgadmin4
flatall org.pgadmin.pgadmin4

### ################################################################################################################################
