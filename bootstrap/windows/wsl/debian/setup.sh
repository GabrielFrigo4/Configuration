#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup System
### ################################

# Make Gabriel Frigo SUDO
usermod -aG sudo gabriel

# Add Non-Free to APT
sudo sed -i 's/main non-free-firmware/main non-free-firmware contrib non-free/' /etc/apt/sources.list

# Update and Upgrade
sudo apt update
sudo apt upgrade -y

# Install MAN
sudo apt install --yes manpages
sudo apt install --yes man-db

# Install DOAS
sudo apt install --yes doas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit persist :sudo
EOF
sudo chmod 0440 "/etc/doas.conf"

### ################################
### Setup Workspace
### ################################

# Workspace
mkdir -p "${HOME}/Workspace"

### ################################
### Setup Packages
### ################################

# Build Essential
sudo apt install --yes build-essential

# Musl Essential
sudo apt install --yes musl
sudo apt install --yes musl-dev
sudo apt install --yes musl-tools

# Utils
sudo apt install --yes binutils
sudo apt install --yes coreutils

# Compress
sudo apt install --yes unzip
sudo apt install --yes zip
sudo apt install --yes tar

# Build System 
sudo apt install --yes make
sudo apt install --yes cmake
sudo apt install --yes meson
sudo apt install --yes ninja-build

# Build Docs 
sudo apt install --yes doxygen

# Web GET
sudo apt install --yes wget
sudo apt install --yes wget2
sudo apt install --yes curl

### ################################
### Setup Git
### ################################

# Install Git Ecosystem
sudo apt install --yes git
sudo apt install --yes git-credential-oauth
sudo apt install --yes gh

# Install GCM
GCM_VER="$(curl -Ls -o "/dev/null" -w %{url_effective} "https://github.com/git-ecosystem/git-credential-manager/releases/latest" | awk -F/ '{print $(NF)}' | sed 's/^v//')"
wget -O gcm.deb "https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VER}/gcm-linux-x64-${GCM_VER}.deb"
sudo apt install --yes "./gcm.deb"
rm "./gcm.deb"

# Git Config
rm "${HOME}/.gitconfig"
git config --global credential.helper '!gh auth git-credential'
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "Gabriel Frigo"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

# GitHub Config
gh auth login
gh auth setup-git

### ################################
### Setup LXC
### ################################

# Install LXC
sudo apt install --yes lxc
sudo apt install --yes lxc-templates
sudo systemctl enable --now lxc-net
sudo systemctl enable --now lxc

# Install Incus
sudo apt install --yes incus
sudo systemctl enable --now incus.socket
sudo usermod -aG incus-admin "$(id -un)"
newgrp incus-admin

# Setup Incus
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
### Setup Nushell
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
### RobotoMono Nerd Fonts
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip" -O "RobotoMono.zip"
unzip -o RobotoMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/LICENSE.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f RobotoMono.zip

### ################################
### JetBrains Nerd Fonts
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O "JetBrainsMono.zip"
unzip -o JetBrainsMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/OFL.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f JetBrainsMono.zip

### ################################
### MesloLGS Nerd Fonts
### ################################

# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
# MesloLGS NF Regular
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -O "MesloLGS NF Regular.ttf"
mv "MesloLGS NF Regular.ttf" "${HOME}/.local/share/fonts"
# MesloLGS NF Bold
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -O "MesloLGS NF Bold.ttf"
mv "MesloLGS NF Bold.ttf" "${HOME}/.local/share/fonts"
# MesloLGS NF Italic
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -O "MesloLGS NF Italic.ttf"
mv "MesloLGS NF Italic.ttf" "${HOME}/.local/share/fonts"
# MesloLGS NF Bold Italic
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -O "MesloLGS NF Bold Italic.ttf"
mv "MesloLGS NF Bold Italic.ttf" "${HOME}/.local/share/fonts"

### ################################
### JetBrains Mono Nerd Fonts
### ################################

# https://github.com/JetBrains/JetBrainsMono
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

### ################################
### Nerd Font Symbols Only
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip" -O "NerdFontsSymbolsOnly.zip"
unzip -o "NerdFontsSymbolsOnly.zip" -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/10-nerd-font-symbols.conf"
rm -f "${HOME}/.local/share/fonts/LICENSE"
rm -f "${HOME}/.local/share/fonts/README.md"
rm "NerdFontsSymbolsOnly.zip"

### ################################
### Update Font Cache
### ################################

fc-cache -f

### ################################################################################################################################

### ################################
### Installing System Tools
### ################################

# Clipboard
sudo apt install --yes wl-clipboard
sudo apt install --yes xclip xsel

### ################################
### Installing Container Tools
### ################################

# Podman
sudo apt install --yes podman

# Docker
sudo apt install --yes docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$(id -un)"

### ################################
### Installing Web/Net Tools
### ################################

# Search
touch "${HOME}/.w3m/history"
sudo apt install --yes elinks w3m lynx

### ################################################################################################################################

### ################################
### Installing System Libraries
### ################################

# Installing Ssl-Lib
sudo apt install --yes openssl
sudo apt install --yes libssl-dev
sudo apt install --yes libsodium-dev
# Installing Yaml-Lib
sudo apt install --yes libfyaml-dev
sudo apt install --yes libfyaml-utils
sudo apt install --yes libfyaml0

### ################################################################################################################################

### ################################
### Installing Languages
### ################################

# Assembly
sudo apt install --yes nasm
sudo apt install --yes fasm
# C/C++
sudo apt install --yes clang clang-tools clangd lldb
sudo apt install --yes musl-tools
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"
# Rust
sudo apt install --yes rustup
rustup update
rustup default stable
rustup toolchain install stable
# Go
sudo apt install --yes golang
# JavaScript
curl -fsSL "https://bun.sh/install" | bash
curl -fsSL "https://deno.land/x/install/install.sh" | bash
sudo apt install --yes nodejs
sudo apt install --yes npm
# Python
sudo apt install --yes python3
sudo apt install --yes pypy3
sudo apt install --yes mypy
cargo install --git https://github.com/RustPython/RustPython rustpython
# Lua
sudo apt install --yes lua5.4
sudo apt install --yes liblua5.4-dev
sudo apt install --yes liblua5.4-0
sudo apt install --yes luajit
# Lisp
sudo apt install --yes sbcl

### ################################################################################################################################

### ################################
### Installing LSP Servers
### ################################

# Formatter LSP
cargo install stylua

# Assembly LSP
cargo install asm-lsp

# Clang LSP
sudo apt install --yes clangd
mkdir -p "${HOME}/.config/clangd"
cat << 'EOF' | tee "${HOME}/.config/clangd/config.yaml" > "/dev/null"
CompileFlags:
  Add:
    - -Wformat=2
    - -Wall
    - -Wextra
    - -Wvla
    - -Wpedantic
    - -Wshadow
    - -Wconversion
    - -Wsign-conversion
    - -Werror
    - -Wno-cpp
    - -Wno-missing-field-initializers
    - -Wno-unknown-warning-option
    - -D_DEFAULT_SOURCE
    - -D_POSIX_C_SOURCE=202405L
    - -D_FORTIFY_SOURCE=2

---

If:
  PathMatch: .*\.(c|h)$
CompileFlags:
  Add: [-std=c23]

---

If:
  PathMatch: .*\.(cpp|cxx|cc|hpp|hxx)$
CompileFlags:
  Add: [-std=c++23]
  Remove: [-std=c23]

---

If:
  PathMatch: .*\.h$
CompileFlags:
  Add: [-xc-header]
EOF

# Clang Formatter
cat << 'EOF' | tee "${HOME}/.clang-format" > "/dev/null"
BasedOnStyle: Microsoft

AllowShortFunctionsOnASingleLine: Empty
KeepEmptyLinesAtTheStartOfBlocks: false

AlignAfterOpenBracket: BlockIndent
BinPackArguments: false
PenaltyBreakAssignment: 4096
ColumnLimit: 96

UseTab: ForIndentation
AccessModifierOffset: -4
IndentWidth: 4
TabWidth: 4
EOF

# Prettier Formatter
cat << 'EOF' | tee "${HOME}/.prettierrc" > "/dev/null"
{
	"printWidth": 96,
	"tabWidth": 4,
	"useTabs": true,
	"semi": true,
	"singleQuote": false,
	"trailingComma": "all",
	"bracketSpacing": true,
	"arrowParens": "always"
}
EOF

# StyLua Formatter
cat << 'EOF' | tee "${HOME}/.stylua.toml" > "/dev/null"
column_width = 96
line_endings = "Unix"
indent_type = "Tabs"
indent_width = 4
quote_style = "AutoPreferDouble"
call_parentheses = "Always"
collapse_simple_statement = "Never"
EOF

### ################################################################################################################################

### ################################
### Installing JavaScript Packages
### ################################

# Formatter
sudo npm install --global prettier@latest
# Database
sudo npm install --global firebase-tools@latest
# Internet
sudo npm install --global localtunnel@latest

### ################################
### Installing Python Packages
### ################################

# Package Manager
sudo apt install --yes python3-venv
sudo apt install --yes python3-pip
sudo apt install --yes pipx
sudo apt install --yes mypy
pipx install uv

# Cython
sudo apt install --yes cython3
# Binary
sudo apt install --yes python3-ropgadget
sudo apt install --yes python3-pwntools
# Math
sudo apt install --yes python3-pulp
# Net
sudo apt install --yes python3-websockets

### ################################
### Installing Lua Packages
### ################################

# Package Manager
LUAROCKS_VER="$(curl -sL "https://api.github.com/repos/luarocks/luarocks/releases/latest" | grep "tag_name" | cut -d '"' -f 4 | sed 's/^v//')"
wget "https://luarocks.org/releases/luarocks-$LUAROCKS_VER.tar.gz"
tar zxpf "luarocks-$LUAROCKS_VER.tar.gz"
rm "luarocks-$LUAROCKS_VER.tar.gz"
cd "luarocks-$LUAROCKS_VER"
./configure
make
sudo make install
cd ..
rm -f -r "luarocks-$LUAROCKS_VER"

# https://luarocks.org/
sudo luarocks install lua-cjson
sudo luarocks install luafilesystem
sudo luarocks install luasocket
sudo luarocks install cffi-lua
sudo luarocks install lpeg

# New STD Libraries
sudo luarocks install penlight

### ################################################################################################################################

### ################################
### Installing Terminal Editor
### ################################

sudo apt install --yes micro
sudo apt install --yes hx
sudo apt install --yes neovim
sudo apt install --yes vim

### ################################
### Installing Git Config
### ################################

# NeoVim
mkdir -p "${HOME}/.config/nvim"
git clone "https://github.com/GabrielFrigo4/nvim.git" "${HOME}/.config/nvim"
# Vim
git clone "https://github.com/GabrielFrigo4/vimfiles.git" "${HOME}/vimfiles"
cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/vimfiles
source ~/vimfiles/vimrc
EOF
# Helix
git clone "https://github.com/GabrielFrigo4/helix.git" "${HOME}/.config/helix"
cat << 'EOF' | tee "${HOME}/.local/bin/hx" > "/dev/null"
#!/usr/bin/bash
/usr/bin/hx "$@"
echo -e -n "\x1b[\x30 q"
EOF
chmod +x "${HOME}/.local/bin/hx"

### ################################
### Updating Git Config
### ################################

cd "${HOME}/.config/nvim"
git pull
cd "${HOME}/vimfiles"
git pull
cd "${HOME}/.config/helix"
git pull
cd "${HOME}"

### ################################
### Installing Theme in Micro
### ################################

### https://draculatheme.com/micro
git clone "https://github.com/dracula/micro.git"
mkdir -p "${HOME}/.config/micro/colorschemes"
cp "micro/dracula.micro" "${HOME}/.config/micro/colorschemes/dracula.micro"
sudo rm -f -r micro
cat << 'EOF' | tee "${HOME}/.config/micro/settings.json" > "/dev/null"
{
	"colorscheme": "dracula"
}
EOF

### ################################################################################################################################

### ################################
### Installing CLI Tools
### ################################

# Firebase
curl -sL "https://firebase.tools" | sudo upgrade=true bash
# Fetch
sudo apt install --yes fastfetch
# Files Tools
sudo apt install --yes dos2unix
# Executables Tools
sudo apt install --yes checksec
# Rust Tools
sudo apt install --yes eza
sudo apt install --yes bat
sudo apt install --yes fd-find
sudo apt install --yes ripgrep
# Cargo Tools
cargo install cargo-update
cargo install-update -a
# TeX / LaTeX
sudo apt install --yes texlive-latex-extra
sudo apt install --yes texlive-lang-portuguese
# Pandoc
sudo apt install --yes pandoc
sudo apt install --yes weasyprint
# Convert
sudo apt install --yes imagemagick
sudo apt install --yes ffmpeg
# Dada Base
sudo apt install --yes postgresql
# Security
sudo apt install --yes dirb

### ################################
### Alias Rust Tools
### ################################

# Alias BatCat
cat << 'EOF' | sudo tee "/usr/local/bin/bat" > "/dev/null"
#!/bin/bash
batcat "$@"
EOF
sudo chmod +x "/usr/local/bin/bat"

# Alias Fd-Find
cat << 'EOF' | sudo tee "/usr/local/bin/fd" > "/dev/null"
#!/bin/bash
fdfind "$@"
EOF
sudo chmod +x "/usr/local/bin/fd"

### ################################################################################################################################
