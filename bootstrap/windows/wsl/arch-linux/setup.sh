#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup ArchWSL
### ################################

echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
useradd -m -G wheel -s /usr/bin/bash gabriel
passwd gabriel
arch.exe config --default-user gabriel

### ################################
### Setup PacMan
### ################################

sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy archlinux-keyring
sudo pacman -Su

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

rm "${HOME}/.gitconfig"
git config --global credential.helper '!gh auth git-credential'
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "Gabriel Frigo"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

gh auth login
gh auth setup-git

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
### Installing Build System Tools
### ################################

sudo pacman --needed --noconfirm -S make
sudo pacman --needed --noconfirm -S cmake
sudo pacman --needed --noconfirm -S ninja
sudo pacman --needed --noconfirm -S meson

### ################################################################################################################################

### ################################
### Installing Yay
### ################################

cd /tmp
git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si
cd ~

### ################################
### Updating Yay
### ################################

yay --needed --noconfirm -Syyuu

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
### Installing PowherShell
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
### Installing System Wayland
### ################################

yay --needed --noconfirm -S wayland
yay --needed --noconfirm -S lib32-wayland
yay --needed --noconfirm -S hyprwayland-scanner
yay --needed --noconfirm -S wayland-protocols

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

# Search
touch "${HOME}/.w3m/history"
yay --needed --noconfirm -S elinks w3m lynx

# Tools
yay --needed --noconfirm -S openssh mosh sshpass
yay --needed --noconfirm -S lftp mutt nettle rsync

# Dev
yay --needed --noconfirm -S ngrok

### ################################
### Installing Wine Tools
### ################################

# Wine
yay --needed --noconfirm -S wine

### ################################################################################################################################

### ################################
### Installing System Libraries
### ################################

# Installing Sys-Lib
yay --needed --noconfirm -S ctags
yay --needed --noconfirm -S gtk3 gtk4
yay --needed --noconfirm -S ncurses
yay --needed --noconfirm -S jansson
# Installing Dev-Lib (64 bits)
yay --needed --noconfirm -S gcc-libs
yay --needed --noconfirm -S alsa-lib
yay --needed --noconfirm -S openal
# Installing Dev-Lib (32 bits)
yay --needed --noconfirm -S lib32-gcc-libs
yay --needed --noconfirm -S lib32-alsa-lib
yay --needed --noconfirm -S lib32-openal

### ################################
### Installing Editor Libraries
### ################################

# Tree-Sitter
yay --needed --noconfirm -S tree-sitter
yay --needed --noconfirm -S tree-sitter-cli
yay --needed --noconfirm -S tree-sitter-grammar

### ################################
### Installing C Libraries
### ################################

# Data Structures
yay --needed --noconfirm -S klib
yay --needed --noconfirm -S glibc
# Data Serialization
yay --needed --noconfirm -S libfyaml
# LibArchive
yay --needed --noconfirm -S libarchive
# LibSndFile
yay --needed --noconfirm -S libsndfile
# ZMQ
yay --needed --noconfirm -S zeromq
yay --needed --noconfirm -S cppzmq

### ################################
### Installing Haskell Libraries
### ################################

# Install Glasgow Haskell
yay --needed --noconfirm -S ghc-static
yay --needed --noconfirm -S ghc-libs

### ################################
### Installing Python Libraries
### ################################

# Net
yay --needed --noconfirm -S python-websockets
yay --needed --noconfirm -S python-pystun3

### ################################
### Installing Frameworks
### ################################

# Install Love2D
yay --needed --noconfirm -S love

### ################################################################################################################################

### ################################
### Installing Languages
### ################################

# Assembly
yay --needed --noconfirm -S nasm
yay --needed --noconfirm -S fasm
yay --needed --noconfirm -S fasmg
yay --needed --noconfirm -S fasm2
yay --needed --noconfirm -S fasmarm
# C/C++
yay --needed --noconfirm -S gcc
yay --needed --noconfirm -S clang llvm lld lldb
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"
# Zig
yay --needed --noconfirm -S zig
# Rust
yay --needed --noconfirm -S rust
rustup update
rustup default stable
rustup toolchain install stable
# Go
yay --needed --noconfirm -S go
# Haskell
yay --needed --noconfirm -S cabal-install
yay --needed --noconfirm -S stack
yay --needed --noconfirm -S ghc
# C#
yay --needed --noconfirm -S dotnet-sdk
# Java
yay --needed --noconfirm -S jdk-openjdk
# JavaScript
yay --needed --noconfirm -S bun
yay --needed --noconfirm -S deno
yay --needed --noconfirm -S nodejs
yay --needed --noconfirm -S npm
# Python
yay --needed --noconfirm -S python
yay --needed --noconfirm -S pypy3
yay --needed --noconfirm -S pypy
yay --needed --noconfirm -S mypy
cargo install --git https://github.com/RustPython/RustPython rustpython
# Lua
yay --needed --noconfirm -S lua
yay --needed --noconfirm -S luajit
yay --needed --noconfirm -S nelua
# Lisp
yay --needed --noconfirm -S sbcl

### ################################################################################################################################

### ################################
### Installing LSP Servers
### ################################

# Formatter LSP
yay --needed --noconfirm -S prettier
yay --needed --noconfirm -S stylua

# Assembly LSP
yay --needed --noconfirm -S asm-lsp

# Clang LSP
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
### Installing Shell Tools
### ################################

# GNU Tools
yay --needed --noconfirm -S gdb
# Files Tools
yay --needed --noconfirm -S dos2unix
# Executables Tools
yay --needed --noconfirm -S checksec
# Rust Tools
yay --needed --noconfirm -S fd
yay --needed --noconfirm -S bat
yay --needed --noconfirm -S eza
yay --needed --noconfirm -S grex
yay --needed --noconfirm -S ripgrep
yay --needed --noconfirm -S repgrep
# Cargo Tools
cargo install cargo-update
cargo install-update -a
# PDF
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
# TeX / LaTeX
yay --needed --noconfirm -S texlive
yay --needed --noconfirm -S texlive-core
yay --needed --noconfirm -S texlive-latexextra
yay --needed --noconfirm -S texlive-langportuguese
yay --needed --noconfirm -S texlive-fontsextra
yay --needed --noconfirm -S texlive-pictures
yay --needed --noconfirm -S texlive-pstricks
yay --needed --noconfirm -S auctex
# Pandoc
yay --needed --noconfirm -S pandoc-plot
yay --needed --noconfirm -S pandoc-cli
# OCR
yay --needed --noconfirm -S gocr
yay --needed --noconfirm -S ocrad
yay --needed --noconfirm -S tesseract
# FFmpeg
yay --needed --noconfirm -S ffmpeg
# Media
yay --needed --noconfirm -S yt-dlp
yay --needed --noconfirm -S ytui
yay --needed --noconfirm -S ani-cli
# Fetch
yay --needed --noconfirm -S fastfetch

### ################################################################################################################################

### ################################
### Installing JavaScript Packages
### ################################

sudo npm install --global localtunnel@latest
sudo npm install --global firebase-tools@latest

### ################################################################################################################################

### ################################
### Installing Python Packages
### ################################

yay --needed --noconfirm -S python-pip
yay --needed --noconfirm -S python-pipx
yay --needed --noconfirm -S uv

# https://bootstrap.pypa.io/get-pip.py
wget "https://bootstrap.pypa.io/get-pip.py"
python get-pip.py
rm -f get-pip.py
python -m pip install --upgrade pip

yay -S cython

### ################################################################################################################################

### ################################
### Installing Lua Packages
### ################################

yay --needed --noconfirm -S luarocks
yay --needed --noconfirm -S meson

# https://luarocks.org/
sudo luarocks install lua-cjson
sudo luarocks install luafilesystem
sudo luarocks install luasocket
sudo luarocks install cffi-lua
sudo luarocks install alien

# new set of libraries (std)
sudo luarocks install penlight

### ################################################################################################################################

### ################################
### Installing Development Software
### ################################

# Git Credential
yay --needed --noconfirm -S git-credential-manager-bin
git-credential-manager configure

# Firebase
curl -sL "https://firebase.tools" | sudo upgrade=true bash

### ################################################################################################################################

### ################################
### Installing Terminal Editor
### ################################

yay --needed --noconfirm -S micro
yay --needed --noconfirm -S helix
yay --needed --noconfirm -S neovim
yay --needed --noconfirm -S gvim
yay --needed --noconfirm -S emacs

### ################################
### Installing Git Config
### ################################

# Emacs
mkdir -p "${HOME}/.emacs.d"
git clone "https://github.com/GabrielFrigo4/.emacs.d.git" "${HOME}/.emacs.d"
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
cat << 'EOF' | sudo tee "/usr/bin/hx" > "/dev/null"
#!/usr/bin/sh
helix "$@"
echo -e -n "\x1b[\x30 q"
EOF
sudo chmod +x "/usr/bin/hx"

### ################################
### Updating Git Config
### ################################

cd "${HOME}/.emacs.d"
git pull
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
