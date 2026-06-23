#!/bin/sh

### ################################################################################################################################

### ################################
### Setup System (Root)
### ################################

# GROUPS
pw groupmod wheel -m "$(id -un)"
pw groupmod operator -m "$(id -un)"
pw groupmod video -m "$(id -un)"
pw groupmod webcamd -m "$(id -un)"

# PACKAGE
pkg bootstrap --yes
pkg update
pkg upgrade --yes

# TERMINAL
sysrc allscreens_flags="-f spleen-16x32"

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
### Setup Environment (Root)
### ################################

# DESKTOP
pkg install --yes desktop-installer
desktop-installer

# COREDUMP
sysctl kern.coredump=0
cat << 'EOF' | tee -a "/etc/sysctl.conf" > "/dev/null"
kern.coredump=0
EOF

### ################################
### Setup Environment (User)
### ################################

# XDG / FREEDESKTOP
pkg install --yes xdg-utils

# SDDM
sudo chown -R sddm:sddm "/var/lib/sddm"

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

### ################################
### Setup Jails (User)
### ################################

# JAILS
sudo sysrc jail_enable="YES"

### ################################
### Setup Containers (User)
### ################################

# BASTILLE
sudo pkg install --yes bastille
sudo sysrc bastille_enable="YES"
sudo service bastille start

### ################################################################################################################################

### ################################
### Config Shell (User)
### ################################

# Default Shell
sudo chsh -s "$(which sh)" "$(id -un)"
sudo chsh -s "$(which sh)" "root"

### ################################################################################################################################

### ################################
### Installing System Fonts (User)
### ################################

# User Local Fonts
sudo pkg install --yes fontconfig
mkdir -p "${HOME}/.local/share/fonts"

### ################################
### Microsoft System Fonts (User)
### ################################

# Microsoft Fonts
sudo pkg install --yes webfonts
sudo pkg install --yes crosextrafonts-caladea
sudo pkg install --yes crosextrafonts-carlito

### ################################
### RobotoMono Nerd Fonts (User)
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip" -O "RobotoMono.zip"
unzip -o RobotoMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/LICENSE.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f RobotoMono.zip

### ################################
### JetBrains Nerd Fonts (User)
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O "JetBrainsMono.zip"
unzip -o JetBrainsMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/OFL.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f JetBrainsMono.zip

### ################################
### MesloLGS Nerd Fonts (User)
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
### JetBrains Mono Nerd Fonts (User)
### ################################

# https://github.com/JetBrains/JetBrainsMono
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

### ################################
### Nerd Font Symbols Only (User)
### ################################

# https://www.nerdfonts.com/font-downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip" -O "NerdFontsSymbolsOnly.zip"
unzip -o "NerdFontsSymbolsOnly.zip" -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/10-nerd-font-symbols.conf"
rm -f "${HOME}/.local/share/fonts/LICENSE"
rm -f "${HOME}/.local/share/fonts/README.md"
rm "NerdFontsSymbolsOnly.zip"

### ################################
### Update Font Cache (User)
### ################################

# Reset Cache
fc-cache -fv

### ################################################################################################################################

### ################################
### Setup Konsole Profiles
### ################################

# Shell
cat << 'EOF' | tee "${HOME}/.local/share/konsole/Shell.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/sh
Environment=SHELL_INIT=1,SHELL_TARGET=/bin/sh
Name=Shell
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

# Bash
cat << 'EOF' | tee "${HOME}/.local/share/konsole/Bash.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/usr/local/bin/bash
Environment=SHELL=/usr/local/bin/bash
Name=Bash
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

# Zsh
cat << 'EOF' | tee "${HOME}/.local/share/konsole/Zsh.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/usr/local/bin/zsh
Environment=SHELL=/usr/local/bin/zsh
Name=Zsh
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

### ################################################################################################################################

### ################################
### Setup Real Server
### ################################

# Frigo Server
chmod 0600 "${FRIGO_SERVER_KEY}"
cat << 'EOF' | sudo tee "/usr/local/bin/frigo-server" > "/dev/null"
#!/usr/local/bin/zsh
source "${HOME}/.vault/servers/servers.env"
ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
EOF
sudo chmod +x "/usr/local/bin/frigo-server"

# Orbs Server
chmod 0600 "${ORBS_SERVER_KEY}"
cat << 'EOF' | sudo tee "/usr/local/bin/orbs-server" > "/dev/null"
#!/usr/local/bin/zsh
source "${HOME}/.vault/servers/servers.env"
ssh -i "${ORBS_SERVER_KEY}" "ubuntu@${ORBS_SERVER_IP}"
EOF
sudo chmod +x "/usr/local/bin/orbs-server"

### ################################
### Setup VM Server
### ################################

### ################################################################################################################################

### ################################
### Installing Needed Tools (User)
### ################################

# Man Pages
sudo pkg install --yes mandoc

# Build System
sudo pkg install --yes cmake
sudo pkg install --yes ninja
sudo pkg install --yes meson

# Compress and Decompress
sudo pkg install --yes zip
sudo pkg install --yes unzip
sudo pkg install --yes 7-zip

# Cryptography
sudo pkg install --yes gnupg
sudo pkg install --yes openssl
sudo pkg install --yes libressl

### ################################
### Installing Rust Tools (User)
### ################################

# New Tools
sudo pkg install --yes eza
sudo pkg install --yes fd-find
sudo pkg install --yes bat
sudo pkg install --yes eza
sudo pkg install --yes grex
sudo pkg install --yes ripgrep

### ################################
### Installing System Fetch (User)
### ################################

# Fetch
sudo pkg install --yes neofetch
sudo pkg install --yes fastfetch
sudo pkg install --yes ufetch
sudo pkg install --yes pfetch-rs
sudo pkg install --yes cpufetch

### ################################
### Installing System Tools (User)
### ################################

# Clipboard
sudo pkg install --yes wl-clipboard
sudo pkg install --yes xclip

### ################################
### Installing Web/Net Tools (User)
### ################################

# Browser
touch "${HOME}/.w3m/history"
sudo pkg install --yes w3m
sudo pkg install --yes lynx
sudo pkg install --yes elinks

# NetCat
sudo pkg install --yes netcat

### ################################
### Installing Device Tools (User)
### ################################

# exFAT
sudo pkg install --yes exfat-utils
sudo pkg install --yes fusefs-exfat

# NTFS
sudo pkg install --yes fusefs-ntfs

# EXT2+
sudo pkg install --yes fusefs-ext2

### ################################
### Installing TreeSitter (User)
### ################################

# TreeSitter
sudo pkg install --yes tree-sitter
sudo pkg install --yes tree-sitter-cli
sudo pkg install --yes tree-sitter-grammars
sudo pkg install --yes tree-sitter-graph

### ################################################################################################################################

### ################################
### Installing Editor (User)
### ################################

# Terminal Editor
sudo pkg install --yes neovim
sudo pkg install --yes vim
sudo pkg install --yes helix
sudo pkg install --yes micro
sudo pkg install --yes mg
sudo pkg install --yes nano

# Window Editor
sudo pkg install --yes emacs
sudo pkg install --yes vscode

### ################################
### Installing Git Config (User)
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

### ################################
### Updating Git Config (User)
### ################################

# Update
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
### Setup Emacs Config (User)
### ################################

# Remove Lixo
rm -rf "${HOME}/.emacs" 2> "/dev/null"
rm -rf "${HOME}/.emacs.d" 2> "/dev/null"
rm -rf "${HOME}/.config/emacs" 2> "/dev/null"
rm -rf "${HOME}/.config/doom" 2> "/dev/null"

# Setup Doom Emacs
git clone --depth 1 "https://github.com/doomemacs/doomemacs" "${HOME}/.config/emacs"
mkdir -p "${HOME}/.config/doom/snippets"
~/.config/emacs/bin/doom install --force

# Setup Packages
cat << 'EOF' | tee -a "${HOME}/.config/doom/packages.el" > "/dev/null"
(package! mermaid-mode)
(package! ob-mermaid)
EOF
~/.config/emacs/bin/doom sync

# Setup init.el
sed -i 's/;;tree-sitter/tree-sitter/' "${HOME}/.config/doom/init.el"
sed -i 's/;;(cc +lsp)/(cc +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;(rust +lsp)/(rust +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;python/(python +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;javascript/(javascript +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;typescript/(typescript +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;toml/(toml +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/;;sql/(sql +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el"
sed -i 's/sh[[:space:]]*;/(sh +tree-sitter) ;/' "${HOME}/.config/doom/init.el"
~/.config/emacs/bin/doom sync

# Setup config.el
cat << 'EOF' | tee -a "${HOME}/.config/doom/config.el" > "/dev/null"
;; Configuração de Fonte (JetBrains Mono)
(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16))
;; Ativar Cursor Piscante
(blink-cursor-mode t)

;; Configuração Mermaid
(use-package! mermaid-mode
  :mode "\\.mermaid\\'"
  :mode "\\.mmd\\'"
  :config
  (setq mermaid-mmdc-location "mmdc")
  (setq mermaid-output-format "png"))

(use-package! ob-mermaid
  :after org
  :config
  (setq ob-mermaid-cli-path "mmdc"))
EOF
~/.config/emacs/bin/doom sync

# Update Doom Emacs
~/.config/emacs/bin/doom upgrade

### ################################
### Setup NeoVim Config (User)
### ################################

# Remove Lixo
rm -rf "${HOME}/.config/nvim" 2> "/dev/null"

# Setup LazyVim
git clone "https://github.com/LazyVim/starter" "${HOME}/.config/nvim"
rm -rf "${HOME}/.config/nvim/.git"

# Setup options.lua
cat << 'EOF' | tee -a "${HOME}/.config/nvim/lua/config/options.lua" > "/dev/null"
-- Ativar Cursor Piscante
local cursor_gui = vim.api.nvim_get_option_value("guicursor", {})
local cursor_group = vim.api.nvim_create_augroup('ConfigCursor', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor=' .. cursor_gui .. ',a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor'
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor='
})
EOF

### ################################
### Setup Micro Config (User)
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
### Installing Languages (User)
### ################################

# C/C++
sudo pkg install --yes gcc
sudo pkg install --yes llvm

# Rust
sudo pkg install --yes rust

# Zig
sudo pkg install --yes zig

# Go
sudo pkg install --yes go

# Assembly
sudo pkg install --yes nasm
sudo pkg install --yes fasm

# JavaScript
sudo pkg install --yes deno
sudo pkg install --yes nodejs
sudo pkg install --yes npm

# Python
sudo pkg install --yes python

# Lua
sudo pkg install --yes lua54 lua54-luarocks
sudo pkg install --yes lua53 lua53-luarocks
sudo pkg install --yes lua52 lua52-luarocks
sudo pkg install --yes lua51 lua51-luarocks
sudo pkg install --yes luajit

### ################################################################################################################################

### ################################
### Installing LSP Servers
### ################################

# Formatter LSP
sudo pkg install --yes gopls
sudo pkg install --yes stylua
sudo npm install --global prettier

# Assembly LSP
cargo install asm-lsp

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
### Installing Softwares (User)
### ################################

# Web Browser
sudo pkg install --yes firefox
sudo pkg install --yes chromium

# Office
sudo pkg install --yes pt_BR-libreoffice

# Image
sudo pkg install --yes krita
sudo pkg install --yes gimp

# Reader
sudo pkg install --yes arianna

### ################################################################################################################################
