#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup Pacman
### ################################

sudo pacman-mirrors --fasttrack 5
sudo pacman --needed --noconfirm -Syyu

### ################################
### Setup System
### ################################

sudo echo ${"$(sudo cat /etc/sddm.conf)"/'Numlock=none'/'Numlock=on'} | sudo tee "/etc/sddm.conf" > "/dev/null"
sudo echo ${"$(sudo cat /etc/sddm.conf)"/'EnableHiDPI=false'/'EnableHiDPI=true'} | sudo tee "/etc/sddm.conf" > "/dev/null"

### ################################
### Setup Journald
### ################################

sudo journalctl --vacuum-size=256M
sudo mkdir -p "/etc/systemd/journald.conf.d/"
cat << 'EOF' | sudo tee "/etc/systemd/journald.conf.d/00-size-limit.conf" > "/dev/null"
[Journal]
SystemMaxUse=256M
EOF
sudo systemctl restart systemd-journald

### ################################
### Setup DOAS
### ################################

sudo pacman --needed --noconfirm -S opendoas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit persist :wheel
EOF
sudo chmod 0440 "/etc/doas.conf"

### ################################################################################################################################

### ################################
### Installing Needed Tools
### ################################

sudo pacman --needed --noconfirm -S base-devel
sudo pacman --needed --noconfirm -S musl

sudo pacman --needed --noconfirm -S zip
sudo pacman --needed --noconfirm -S unzip
sudo pacman --needed --noconfirm -S 7zip

sudo pacman --needed --noconfirm -S wget
sudo pacman --needed --noconfirm -S wget2
sudo pacman --needed --noconfirm -S curl

sudo pacman --needed --noconfirm -S man-db
sudo pacman --needed --noconfirm -S man-pages
sudo pacman --needed --noconfirm -S qman

### ################################
### Installing Git Tools
### ################################

sudo pacman --needed --noconfirm -S git
sudo pacman --needed --noconfirm -S git-credential-oauth
sudo pacman --needed --noconfirm -S github-cli

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/../../../common/git.sh"

### ################################
### Installing LXC Tools
### ################################

sudo pacman --needed --noconfirm -S lxc
sudo systemctl enable --now lxc-net.service
sudo systemctl enable --now lxc.service

sudo pacman --needed --noconfirm -S incus
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

### ################################
### Installing Core Utils
### ################################

sudo pacman --needed --noconfirm -S coreutils
sudo pacman --needed --noconfirm -S uutils-coreutils

### ################################
### Installing Connection Tools
### ################################

sudo pacman --needed --noconfirm -S bluez-utils
sudo pacman --needed --noconfirm -S iwd

### ################################
### Installing Bootable Tools
### ################################

sudo pacman --needed --noconfirm -S ventoy

### ################################
### Setup Workspace
### ################################

mkdir -p "${HOME}/Workspace"

### ################################################################################################################################

### ################################
### Installing Graphics Drivers
### ################################

sudo pacman --needed --noconfirm -S intel-media-driver
sudo pacman --needed --noconfirm -S libva-nvidia-driver
sudo pacman --needed --noconfirm -S libva-intel-driver
sudo pacman --needed --noconfirm -S libva-utils
sudo pacman --needed --noconfirm -S libva
sudo pacman --needed --noconfirm -S mesa

### ################################
### Installing Vulkan Tools
### ################################

sudo pacman --needed --noconfirm -S vulkan-devel
sudo pacman --needed --noconfirm -S spirv-tools

### ################################
### Installing Shader Tools
### ################################

sudo pacman --needed --noconfirm -S directx-shader-compiler
sudo pacman --needed --noconfirm -S shaderc
sudo pacman --needed --noconfirm -S glslang

### ################################
### Installing OneAPI Tools
### ################################

sudo pacman --needed --noconfirm -S intel-oneapi-basekit

### ################################################################################################################################

### ################################
### Installing Linux Kernel
### ################################

export LINUX_VER="$(mhwd-kernel -li |grep running |cut -d"(" -f2 |cut -d")" -f1)"
sudo pacman --needed --noconfirm -S $LINUX_VER-headers
sudo pacman --needed --noconfirm -S dkms

### ################################################################################################################################

### ################################
### Installing System Rules
### ################################

# https://docs.platformio.org/en/latest/core/installation/udev-rules.html
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules > "/dev/null"

cat << 'EOF' | sudo tee "/etc/udev/rules.d/99-ds4.rules" > "/dev/null"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
EOF

### ################################################################################################################################

### ################################
### Installing Pacman Contrib
### ################################

sudo pacman --needed --noconfirm -S pacman-contrib

### ################################
### Installing Yay
### ################################

cd "/tmp"
git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si
cd ~

### ################################
### Updating Yay
### ################################

yay --needed --noconfirm -Syyuu

### ################################
### Installing Flatpak
### ################################

yay --needed --noconfirm -S flatpak

### ################################
### Setup Flathub
### ################################

flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
alias flatall="flatpak override --user --filesystem=host --share=ipc --share=network --socket=system-bus --socket=session-bus --device=all --talk-name=org.freedesktop.Flatpak"

### ################################################################################################################################

### ################################
### Installing Bash
### ################################

yay --needed --noconfirm -S bash

### ################################
### Installing Zsh
### ################################

yay --needed --noconfirm -S zsh
sudo chsh -s "$(which zsh)" "$(id -un)"
sudo chsh -s "$(which zsh)" "root"

yay --needed --noconfirm -S zsh-theme-powerlevel10k
p10k configure

### ################################
### Installing Nushell
### ################################

yay --needed --noconfirm -S nushell
yay --needed --noconfirm -S oh-my-posh
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

### ################################
### Installing PowerShell
### ################################

yay --needed --noconfirm -S powershell-bin
oh-my-posh init pwsh --config "${HOME}/.oh-my-posh/atomic.omp.json" > "${HOME}/.oh-my-posh.ps1"
cat << 'EOF' | tee -a "${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

### ################################
### SHELL OH-MY-POSH
### ################################

. "~/.oh-my-posh.ps1";
Import-Module Terminal-Icons;

### ################################
### SHELL FUNCTIONS
### ################################

### ################################
### SHELL ALIAS
### ################################

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################################################################################################################

### ################################
### Installing System Fonts
### ################################

yay --needed --noconfirm -S fontconfig
mkdir -p "${HOME}/.local/share/fonts"

### ################################
### Microsoft System Fonts
### ################################

yay --needed --noconfirm -S ttf-ms-win11-auto
yay --needed --noconfirm -S ttf-carlito

### ################################
### Nerd Fonts
### ################################

. "${SCRIPT_DIR}/../../../common/fonts.sh"

### ################################################################################################################################

### ################################
### Setup Real Server
### ################################

chmod 0600 "${FRIGO_SERVER_KEY}"
cat << EOF | sudo tee "/usr/local/bin/frigo-server" > "/dev/null"
#!/bin/sh
ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
EOF
sudo chmod +x "/usr/local/bin/frigo-server"

chmod 0600 "${ORBS_SERVER_KEY}"
cat << EOF | sudo tee "/usr/local/bin/orbs-server" > "/dev/null"
#!/bin/sh
ssh -i "${ORBS_SERVER_KEY}" "ubuntu@${ORBS_SERVER_IP}"
EOF
sudo chmod +x "/usr/local/bin/orbs-server"

### ################################
### Setup VM Server
### ################################

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-start" > "/dev/null"
#!/usr/bin/zsh
virsh --connect "qemu:///system" start FreeBSD
EOF
sudo chmod +x "/usr/local/bin/freebsd-start"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-close" > "/dev/null"
#!/usr/bin/zsh
virsh --connect "qemu:///system" destroy FreeBSD
EOF
sudo chmod +x "/usr/local/bin/freebsd-close"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-restart" > "/dev/null"
#!/usr/bin/zsh
virsh --connect "qemu:///system" reboot FreeBSD
EOF
sudo chmod +x "/usr/local/bin/freebsd-restart"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-server" > "/dev/null"
#!/usr/bin/zsh
FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr FreeBSD | awk '$(3) == "ipv4" {print $(4)}' | cut -d'/' -f1)"
ssh "freebsd@${FREEBSD_IP}"
EOF
sudo chmod +x "/usr/local/bin/freebsd-server"

### ################################################################################################################################

### ################################
### Installing System Wayland
### ################################

yay --needed --noconfirm -S wayland
yay --needed --noconfirm -S lib32-wayland
yay --needed --noconfirm -S hyprwayland-scanner
yay --needed --noconfirm -S wayland-protocols

### ################################
### Installing KDE Tools
### ################################

yay --needed --noconfirm -S kde-applications
yay --needed --noconfirm -S kde-utilities

### ################################
### Installing GNOME Tools
### ################################

yay --needed --noconfirm -S gnome-screenshot

### ################################
### Installing System Tools
### ################################

yay --needed --noconfirm -S xremap-kde-bin
yay --needed --noconfirm -S wl-clipboard
yay --needed --noconfirm -S xclip xsel
yay --needed --noconfirm -S dbus

### ################################
### Installing Container Tools
### ################################

yay --needed --noconfirm -S podman

yay --needed --noconfirm -S docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$(id -un)"

### ################################
### Installing Web/Net Tools
### ################################

yay --needed --noconfirm -S networkmanager-openvpn
yay --needed --noconfirm -S openvpn

touch "${HOME}/.w3m/history"
yay --needed --noconfirm -S elinks w3m lynx

yay --needed --noconfirm -S openssh mosh sshpass
yay --needed --noconfirm -S lftp mutt nettle rsync
yay --needed --noconfirm -S openbsd-netcat

yay --needed --noconfirm -S ngrok

### ################################
### Installing Wine Tools
### ################################

yay --needed --noconfirm -S wine

### ################################################################################################################################

### ################################
### Installing Rust CLI Tools
### ################################

yay --needed --noconfirm -S fd
yay --needed --noconfirm -S bat
yay --needed --noconfirm -S eza
yay --needed --noconfirm -S grex
yay --needed --noconfirm -S ripgrep
yay --needed --noconfirm -S repgrep

### ################################
### Installing Embedded Tools
### ################################

yay --needed --noconfirm -S platformio-core

### ################################
### Installing PDF Tools
### ################################

yay --needed --noconfirm -S pdftk
yay --needed --noconfirm -S img2pdf
yay --needed --noconfirm -S jbig2enc
yay --needed --noconfirm -S poppler
yay --needed --noconfirm -S mscgen
yay --needed --noconfirm -S pdf2svg
yay --needed --noconfirm -S enchant
yay --needed --noconfirm -S graphviz
yay --needed --noconfirm -S jpegoptim
yay --needed --noconfirm -S pdfsizeopt-git

### ################################
### Installing TeX / LaTeX
### ################################

yay --needed --noconfirm -S texlive
yay --needed --noconfirm -S texlive-core
yay --needed --noconfirm -S texlive-latexextra
yay --needed --noconfirm -S texlive-langportuguese
yay --needed --noconfirm -S texlive-fontsextra
yay --needed --noconfirm -S texlive-pictures
yay --needed --noconfirm -S texlive-pstricks

### ################################
### Installing Pandoc Tools
### ################################

yay --needed --noconfirm -S pandoc-plot
yay --needed --noconfirm -S pandoc-cli

### ################################
### Installing Media Tools
### ################################

yay --needed --noconfirm -S imagemagick
yay --needed --noconfirm -S ffmpeg
yay --needed --noconfirm -S yt-dlp
yay --needed --noconfirm -S ytui
yay --needed --noconfirm -S ani-cli

### ################################
### Installing OCR Tools
### ################################

yay --needed --noconfirm -S ocrs
yay --needed --noconfirm -S gocr
yay --needed --noconfirm -S ocrad
yay --needed --noconfirm -S tesseract
yay --needed --noconfirm -S tesseract-data-eng
yay --needed --noconfirm -S tesseract-data-por
yay --needed --noconfirm -S ocrmypdf

### ################################
### Installing Hardware Tools
### ################################

yay --needed --noconfirm -S esptool

### ################################
### Installing Security Tools
### ################################

yay --needed --noconfirm -S dirb

### ################################
### Installing System Fetch
### ################################

yay --needed --noconfirm -S fastfetch

### ################################################################################################################################

### ################################
### Installing Terminal Editors
### ################################

yay --needed --noconfirm -S emacs
yay --needed --noconfirm -S neovim
yay --needed --noconfirm -S gvim
yay --needed --noconfirm -S helix
yay --needed --noconfirm -S micro
yay --needed --noconfirm -S mg

### ################################
### Setup Helix Wrapper
### ################################

cat << 'EOF' | sudo tee "/usr/bin/hx" > "/dev/null"
#!/usr/bin/sh
helix "$@"
echo -e -n "\x1b[\x30 q"
EOF
sudo chmod +x "/usr/bin/hx"

### ################################
### Setup Editor Configs
### ################################

. "${SCRIPT_DIR}/../../../common/editors.sh"

### ################################################################################################################################

### ################################
### Installing General Software
### ################################

yay --needed --noconfirm -S libreoffice-still
yay --needed --noconfirm -S onlyoffice-desktopeditors

### ################################
### Installing Web Browsers
### ################################

yay --needed --noconfirm -S microsoft-edge-stable
yay --needed --noconfirm -S google-chrome

### ################################
### Installing Communication Tools
### ################################

yay --needed --noconfirm -S discord
yay --needed --noconfirm -S zoom

### ################################
### Installing Media Software
### ################################

yay --needed --noconfirm -S handbrake
yay --needed --noconfirm -S obs-studio
yay --needed --noconfirm -S feh
yay --needed --noconfirm -S scilab

### ################################
### Installing Drawing Software
### ################################

yay --needed --noconfirm -S gimp
yay --needed --noconfirm -S krita
yay --needed --noconfirm -S inkscape
yay --needed --noconfirm -S libresprite
yay --needed --noconfirm -S blender

### ################################
### Installing CAD Software
### ################################

yay --needed --noconfirm -S freecad

### ################################
### Installing Audio/Peripheral Tools
### ################################

yay --needed --noconfirm -S galaxybudsclient-bin
yay --needed --noconfirm -S etcher-bin

### ################################
### Installing TeX Software
### ################################

yay --needed --noconfirm -S texworks

### ################################
### Installing VMWare
### ################################

yay --needed --noconfirm -S vmware-keymaps
yay --needed --noconfirm -S vmware-workstation

### ################################
### Installing QEMU
### ################################

yay --needed --noconfirm -S qemu-full

### ################################
### Installing Remote Desktop
### ################################

yay --needed --noconfirm -S remmina
yay --needed --noconfirm -S freerdp

### ################################################################################################################################

### ################################
### Installing Reverse Engineering
### ################################

yay --needed --noconfirm -S xelfviewer-bin
yay --needed --noconfirm -S xpeviewer-bin
yay --needed --noconfirm -S xmachoviewer-bin
yay --needed --noconfirm -S xapkdetector-bin
yay --needed --noconfirm -S ghidra

### ################################
### Installing Debuggers
### ################################

yay --needed --noconfirm -S gf2-git

### ################################
### Installing Network Analysis Tools
### ################################

yay --needed --noconfirm -S wireshark-cli
yay --needed --noconfirm -S wireshark-qt
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

yay --needed --noconfirm -S dbeaver

### ################################
### Installing Game Engines
### ################################

yay --needed --noconfirm -S unityhub
yay --needed --noconfirm -S godot

### ################################
### Installing Electronics Tools
### ################################

yay --needed --noconfirm -S arduino-ide-bin
yay --needed --noconfirm -S arduino-cli
yay --needed --noconfirm -S digital
yay --needed --noconfirm -S openfpgaloader
yay --needed --noconfirm -S quartus-free
yay --needed --noconfirm -S gtkwave
yay --needed --noconfirm -S ghdl

### ################################
### Installing Google Tools
### ################################

yay --needed --noconfirm -S gdown

### ################################################################################################################################

### ################################
### Installing Git GUI Tools
### ################################

yay --needed --noconfirm -S github-desktop-bin
yay --needed --noconfirm -S gitkraken-cli-bin
yay --needed --noconfirm -S gitkraken

### ################################
### Installing Git Credential Manager
### ################################

yay --needed --noconfirm -S git-credential-manager-bin
git-credential-manager configure

### ################################
### Installing Firebase
### ################################

curl -sL "https://firebase.tools" | sudo upgrade=true bash
yay --needed --noconfirm -S firebase-tools-bin

### ################################################################################################################################

### ################################
### Installing KVM/QEMU
### ################################

yay --needed --noconfirm -S qemu-desktop
yay --needed --noconfirm -S libvirt
yay --needed --noconfirm -S dnsmasq
yay --needed --noconfirm -S iptables-nft
yay --needed --noconfirm -S edk2-ovmf
yay --needed --noconfirm -S virt-manager
yay --needed --noconfirm -S virt-viewer

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$(id -un)"
sudo virsh --connect qemu:///system net-autostart default
sudo virsh --connect qemu:///system net-start default

### ################################################################################################################################

### ################################
### Installing Code Editors
### ################################

yay --needed --noconfirm -S geany
mkdir -p "${HOME}/.config/geany/colorschemes"
cd "${HOME}/.config/geany/colorschemes"
wget "https://raw.githubusercontent.com/geany/geany-themes/master/colorschemes/one-dark.conf"
cd ~

curl -f https://zed.dev/install.sh | sh
yay --needed --noconfirm -S zed

yay --needed --noconfirm -S visual-studio-code-bin
yay --needed --noconfirm -S vscodium-bin
yay --needed --noconfirm -S code

yay --needed --noconfirm -S antigravity
yay --needed --noconfirm -S antigravity-ide

cat << 'EOF' | sudo tee "/usr/bin/ant" > "/dev/null"
#!/usr/bin/sh
antigravity-ide "$@"
EOF
sudo chmod +x "/usr/bin/ant"

### ################################################################################################################################

### ################################
### Installing Games
### ################################

yay --needed --noconfirm -S steam

### ################################################################################################################################
