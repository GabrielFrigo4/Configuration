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

# Install MESA
sudo apt install --yes libgl1-mesa-dev
sudo apt install --yes libglu1-mesa-dev
sudo apt install --yes mesa-common-dev
sudo apt install --yes mesa-utils

# Install NVIDIA
sudo apt install --yes nvidia-driver
sudo apt install --yes firmware-misc-nonfree

# Install Prerequisites
sudo apt install --yes gnupg
sudo apt install --yes software-properties-common
sudo apt install --yes apt-transport-https
sudo apt install --yes ca-certificates

# Install DOAS
sudo apt install --yes doas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit persist :sudo
EOF
sudo chmod 0440 "/etc/doas.conf"

### ################################
### Setup Init
### ################################

cat << 'EOF' | tee "${HOME}/init" > "/dev/null"
#!/usr/bin/bash

# Emacs Server
emacs --fg-daemon &

# Run as Services
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

# Workspace
mkdir -p "${HOME}/Workspace"

# Firefox NVIDIA
cat << 'EOF' | tee "${HOME}/.local/bin/firefox-nvc" > "/dev/null"
#!/usr/bin/bash
DRI_PRIME=1 /usr/bin/firefox "$@"
EOF
chmod +x "${HOME}/.local/bin/firefox-nvc"

### ################################
### Setup Packages
### ################################

# Flatpak and Flathub
sudo apt install --yes flatpak
sudo apt install --yes gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
alias flatall="flatpak override --user --filesystem=host --share=ipc --share=network --socket=system-bus --socket=session-bus --device=all --talk-name=org.freedesktop.Flatpak"

# GNOME
sudo apt install --yes gnome-themes-extra

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
git config --global credential.helper "!gh auth git-credential"
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
### Setup Shell and Bash
### ################################

cat << 'EOF' | tee -a "${HOME}/.shrc" | tee -a "${HOME}/.bashrc" | sudo tee -a "/root/.shrc" | sudo tee -a "/root/.bashrc" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

path_front() {
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		export PATH="${1}:${PATH}"
	fi
}

path_back() {
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		export PATH="${PATH}:${1}"
	fi
}

path_front "${HOME}/.local/bin"
path_back  "${HOME}/.cargo/bin"
path_back  "${HOME}/.deno/bin"
path_back  "${HOME}/.bun/bin"
path_back  "${HOME}/.platformio/penv/bin"
export PATH=$(printf "%s" "${PATH}" | awk -v RS=: -v ORS=: '!a[$(0)]++' | sed 's/:$//')

export EMACS_SOCKET_NAME="${HOME}/.emacs.d/var/server/auth/server"
export MICRO_TRUECOLOR=1

### ################################
### SHELL APPEARANCE
### ################################

git_branch() {
	if git rev-parse --is-inside-work-tree &> "/dev/null"; then
		local branch="$(git branch --show-current 2> "/dev/null" || git rev-parse --short HEAD 2> "/dev/null")"
		if [ -n "$branch" ]; then
			local is_dirty="$(git status --short -uno 2> "/dev/null" | tail -n1)"
			local indicator=""
			[ -n "$is_dirty" ] && indicator="${C_BRT_YELLOW}*"
			echo "❮${C_BRT_RED}󰊢 ${C_BRT_MAGENTA}${branch}${indicator}${C_NORM_YELLOW}❯"
		fi
	fi
}

update_prompt() {
	local C_RESET="\[\e[0m\]"

	local C_NORM_BLACK="\[\e[0;30m\]"
	local C_NORM_RED="\[\e[0;31m\]"
	local C_NORM_GREEN="\[\e[0;32m\]"
	local C_NORM_YELLOW="\[\e[0;33m\]"
	local C_NORM_BLUE="\[\e[0;34m\]"
	local C_NORM_MAGENTA="\[\e[0;35m\]"
	local C_NORM_CYAN="\[\e[0;36m\]"
	local C_NORM_WHITE="\[\e[0;37m\]"

	local C_BRT_GRAY="\[\e[1;90m\]"
	local C_BRT_RED="\[\e[1;91m\]"
	local C_BRT_GREEN="\[\e[1;92m\]"
	local C_BRT_YELLOW="\[\e[1;93m\]"
	local C_BRT_BLUE="\[\e[1;94m\]"
	local C_BRT_MAGENTA="\[\e[1;95m\]"
	local C_BRT_CYAN="\[\e[1;96m\]"
	local C_BRT_WHITE="\[\e[1;97m\]"

	local os_version="$(uname -r)"
	local sh_name="${0##*/}"
	sh_name="${sh_name#-}"

	local usr_color
	if [ "$(id -u)" -eq 0 ]; then
		usr_color="${C_BRT_RED}"
	else
		usr_color="${C_BRT_GREEN}"
	fi

	PS1="\n${C_NORM_YELLOW}${C_BRT_BLUE} ${C_BRT_MAGENTA}${os_version}${C_NORM_YELLOW}─${C_BRT_BLUE} ${C_BRT_MAGENTA}${sh_name}${C_NORM_YELLOW}"
	PS1+="\n${C_NORM_YELLOW}┌──❮ ${C_BRT_GREEN} \t${C_NORM_YELLOW} ❯─❮ ${C_BRT_GREEN} \D{%d/%m/%y}${C_NORM_YELLOW} ❯─❮ ${C_BRT_YELLOW} ${C_BRT_CYAN}\W${C_NORM_YELLOW} ❯─ ❮${C_BRT_BLUE} ${usr_color}\u${C_NORM_YELLOW}❯ $(git_branch)"
	PS1+="\n${C_NORM_YELLOW}└─${C_BRT_BLUE}${C_RESET} "
}

PROMPT_COMMAND=update_prompt

### ################################
### WINDOWS FUNCTIONS
### ################################

# Manual FUNCTIONS
win-man() {
	start "https://learn.microsoft.com/en-us/search/?terms=${1}"
}

### ################################
### UNIX FUNCTIONS
### ################################

# Manual FUNCTIONS
unix-man() {
	section="${1}"
	command="${2}"
	number="$section"

	if [[ ! "$section" =~ [0-9]$ ]]; then
		number="${section%?}"
	fi

	w3m "https://www.man7.org/linux/man-pages/man$number/$command.$section.html"
}

### ################################
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh="which"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Manual ALIAS
alias wman="win-man"
alias uman="unix-man"
alias mandoc="unix-man"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade -y"
alias upflat="flatpak update -y"
alias upall="upapt && upflat"
alias backusb="./\"#BackupAll\""
# Goto ALIAS
alias desk="cd ~/'Área de trabalho'"
alias down="cd ~/Downloads"
# Emacs ALIAS
alias ek="pkill emacs"
alias es="emacs --daemon"
alias er="ek && es"
alias ec="emacsclient --create-frame --alternate-editor \"\""
alias oe="nohup emacsclient --create-frame --alternate-editor \"\" . &> \"/dev/null\" &"
# Code Editors ALIAS
alias og="nohup geany . &> \"/dev/null\" &"
alias oc="nohup code . &> \"/dev/null\" &"
alias oz="nohup zed . &> \"/dev/null\" &"
alias on="nvim ."
alias ov="vim ."
# Select GPU
alias nvc="DRI_PRIME=1"
alias hdc="DRI_PRIME=0"
# Select Theme
alias dark="GTK_THEME=Adwaita:dark"
alias light="GTK_THEME=Adwaita:light"

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################
### Installing Zsh
### ################################

sudo apt install --yes zsh
sudo chsh -s "$(which zsh)" "$(id -un)"
sudo chsh -s "$(which zsh)" "root"

cat << 'EOF' | tee -a "${HOME}/.zshrc" | sudo tee -a "/root/.zshrc" > "/dev/null"
### ################################
### SHELL OPTIONS SETUP
### ################################

# Expansion OPTIONS
setopt PROMPT_SUBST

# Globbing OPTIONS
setopt EXTENDED_GLOB
setopt GLOB_DOTS

# History OPTIONS
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# Interaction OPTIONS
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt RM_STAR_WAIT
setopt NO_CLOBBER
unsetopt BEEP

# Navigation OPTIONS
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt COMPLETE_IN_WORD

### ################################
### SHELL ENVIRONMENT
### ################################

path_front() {
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		export PATH="${1}:${PATH}"
	fi
}

path_back() {
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		export PATH="${PATH}:${1}"
	fi
}

path_front "${HOME}/.local/bin"
path_back  "${HOME}/.cargo/bin"
path_back  "${HOME}/.deno/bin"
path_back  "${HOME}/.bun/bin"
path_back  "${HOME}/.platformio/penv/bin"
export PATH=$(printf "%s" "${PATH}" | awk -v RS=: -v ORS=: '!a[$(0)]++' | sed 's/:$//')

export EMACS_SOCKET_NAME="${HOME}/.emacs.d/var/server/auth/server"
export MICRO_TRUECOLOR=1

### ################################
### SHELL APPEARANCE
### ################################

() {
	zstyle ':prompt:colors' reset     '%f%b'

	zstyle ':prompt:colors' n_black   '%b%F{0}'
	zstyle ':prompt:colors' n_red     '%b%F{1}'
	zstyle ':prompt:colors' n_green   '%b%F{2}'
	zstyle ':prompt:colors' n_yellow  '%b%F{3}'
	zstyle ':prompt:colors' n_blue    '%b%F{4}'
	zstyle ':prompt:colors' n_magenta '%b%F{5}'
	zstyle ':prompt:colors' n_cyan    '%b%F{6}'
	zstyle ':prompt:colors' n_white   '%b%F{7}'

	zstyle ':prompt:colors' b_gray    '%B%F{8}'
	zstyle ':prompt:colors' b_red     '%B%F{9}'
	zstyle ':prompt:colors' b_green   '%B%F{10}'
	zstyle ':prompt:colors' b_yellow  '%B%F{11}'
	zstyle ':prompt:colors' b_blue    '%B%F{12}'
	zstyle ':prompt:colors' b_magenta '%B%F{13}'
	zstyle ':prompt:colors' b_cyan    '%B%F{14}'
	zstyle ':prompt:colors' b_white   '%B%F{15}'

	git_branch() {
		if git rev-parse --is-inside-work-tree &> "/dev/null"; then
			local branch="$(git branch --show-current 2> "/dev/null" || git rev-parse --short HEAD 2> "/dev/null")"
			if [[ -n "$branch" ]]; then
				local y Y R M
				zstyle -s ':prompt:colors' n_yellow y
				zstyle -s ':prompt:colors' b_yellow Y
				zstyle -s ':prompt:colors' b_red R
				zstyle -s ':prompt:colors' b_magenta M
				local indicator=""
				[[ -n "$(git status --short -uno 2> "/dev/null" | tail -n1)" ]] && indicator="${Y}*"
				echo "❮${R}󰊢 ${M}${branch}${indicator}${y}❯"
			fi
		fi
	}

	local z
	zstyle -s ':prompt:colors' reset z

	local k K r R g G y Y b B m M c C w W
	zstyle -s ':prompt:colors' n_black   k; zstyle -s ':prompt:colors' b_gray    K
	zstyle -s ':prompt:colors' n_red     r; zstyle -s ':prompt:colors' b_red     R
	zstyle -s ':prompt:colors' n_green   g; zstyle -s ':prompt:colors' b_green   G
	zstyle -s ':prompt:colors' n_yellow  y; zstyle -s ':prompt:colors' b_yellow  Y
	zstyle -s ':prompt:colors' n_blue    b; zstyle -s ':prompt:colors' b_blue    B
	zstyle -s ':prompt:colors' n_magenta m; zstyle -s ':prompt:colors' b_magenta M
	zstyle -s ':prompt:colors' n_cyan    c; zstyle -s ':prompt:colors' b_cyan    C
	zstyle -s ':prompt:colors' n_white   w; zstyle -s ':prompt:colors' b_white   W

	local u
	if [ "$(id -u)" -eq 0 ]; then
		zstyle -s ':prompt:colors' b_red u
	else
		zstyle -s ':prompt:colors' b_green u
	fi

	local os_version="$(uname -r)"
	local sh_name="$ZSH_NAME"

	export PROMPT="
${y}${B} ${M}${os_version}${y}─${B} ${M}${sh_name}${y}
${y}┌──❮ ${G} %*${y} ❯─❮ ${G} %D{%d/%m/%y}${y} ❯─❮ ${Y} ${C}%c${y} ❯─ ❮${B} ${u}%n${y}❯ \$(git_branch)
${y}└─${B}${z} "
}

### ################################
### WINDOWS FUNCTIONS
### ################################

# Manual FUNCTIONS
win-man() {
	start "https://learn.microsoft.com/en-us/search/?terms=${1}"
}

### ################################
### UNIX FUNCTIONS
### ################################

# Manual FUNCTIONS
unix-man() {
	section="${1}"
	command="${2}"
	number="$section"

	if [[ ! "$section" =~ [0-9]$ ]]; then
		number="${section%?}"
	fi

	w3m "https://www.man7.org/linux/man-pages/man$number/$command.$section.html"
}

### ################################
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh="which"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Manual ALIAS
alias wman="win-man"
alias uman="unix-man"
alias mandoc="unix-man"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade -y"
alias upflat="flatpak update -y"
alias upall="upapt && upflat"
alias backusb="./\"#BackupAll\""
# Goto ALIAS
alias desk="cd ~/'Área de trabalho'"
alias down="cd ~/Downloads"
# Emacs ALIAS
alias ek="pkill emacs"
alias es="emacs --daemon"
alias er="ek && es"
alias ec="emacsclient --create-frame --alternate-editor \"\""
alias oe="nohup emacsclient --create-frame --alternate-editor \"\" . &> \"/dev/null\" &"
# Code Editors ALIAS
alias og="nohup geany . &> \"/dev/null\" &"
alias oc="nohup code . &> \"/dev/null\" &"
alias oz="nohup zed . &> \"/dev/null\" &"
alias on="nvim ."
alias ov="vim ."
# Select GPU
alias nvc="DRI_PRIME=1"
alias hdc="DRI_PRIME=0"
# Select Theme
alias dark="GTK_THEME=Adwaita:dark"
alias light="GTK_THEME=Adwaita:light"

### ################################
### SHELL CONFIGURATION
### ################################
EOF

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

$env.config.buffer_editor = "code";
$env.config.show_banner = false;

$env.PATH = ($env.PATH 
	| split row (char esep)
	| prepend ($env.HOME | path join .local bin)
	| prepend ($env.HOME | path join .cargo bin)
	| prepend ($env.HOME | path join .deno bin)
	| prepend ($env.HOME | path join .bun bin)
	| prepend ($env.HOME | path join .platformio penv bin)
	| uniq
	| where { |p| $p | path exists }
)

$env.EMACS_SOCKET_NAME = ($env.HOME | path join ".emacs.d" "var" "server" "auth" "server");
$env.MICRO_TRUECOLOR = 1;

### ################################
### SHELL OH-MY-POSH
### ################################

source "~/.oh-my-posh.nu";

### ################################
### WINDOWS FUNCTIONS
### ################################

# Manual FUNCTIONS
def win-man [term: string] {
	start $"https://learn.microsoft.com/en-us/search/?terms=($term)";
};

### ################################
### UNIX FUNCTIONS
### ################################

# Manual FUNCTIONS
def unix-man [section: string, command: string] {
	mut number = $section;
	if (not ('0123456789' | str contains ($section | str substring (-1..)))) {
		$number = $section | str substring (..-2);
	}
	w3m $"https://www.man7.org/linux/man-pages/man($number)/($command).($section).html";
};

### ################################
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh = which;
alias show = start .;
alias mmdc = mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b "#191919" -s 4;
# Manual ALIAS
alias wman = win-man;
alias uman = unix-man;
alias mandoc = unix-man;
# Management ALIAS
alias backusb = ./"#BackupAll";
# Goto ALIAS
alias desk = cd "~/Área de trabalho";
alias down = cd ~/Downloads;
# Emacs ALIAS
alias ek = pkill emacs;
alias es = emacs --daemon;
alias ec = emacsclient --create-frame --alternate-editor "";
alias oe = emacsclient --create-frame --alternate-editor "" .;
# Code Editors ALIAS
alias og = geany .;
alias oc = code .;
alias oz = zed .;
alias on = nvim .;
alias ov = vim .;

### ################################
### SHELL FUNCTIONS
### ################################

# Management FUNC
def upflat [] { flatpak update -y }
def upapt [] { sudo apt update; sudo apt upgrade --yes };
def upall [] { upapt; upflat };

# Emacs FUNC
def er [] { ek; es };
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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

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
sudo apt install --yes universal-ctags
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

# VPN
sudo apt install --yes network-manager-openvpn-gnome
sudo apt install --yes network-manager-openvpn
sudo apt install --yes openvpn

# Search
touch "${HOME}/.w3m/history"
sudo apt install --yes elinks w3m lynx

### ################################
### Installing Wine Tools
### ################################

# Wine
sudo apt install --yes wine

### ################################################################################################################################

### ################################
### Installing Languages
### ################################

# Assembly
sudo apt install --yes nasm
sudo apt install --yes fasm
# C/C++
sudo apt install --yes clang clang-tools clangd lldb
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"
# Rust
sudo apt install --yes rust-all
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

### ################################################################################################################################

### ################################
### Installing System Libraries
### ################################

# Installing Sys-Lib
sudo apt install --yes libxml++2.6-dev
sudo apt install --yes libvterm-dev
# Installing Dev-Lib
sudo apt install --yes libtree-sitter-dev
sudo apt install --yes libminizip-dev
sudo apt install --yes zlib1g-dev
# Installing Ssl-Lib
sudo apt install --yes openssl
sudo apt install --yes libssl-dev
sudo apt install --yes libsodium-dev
# Installing Yaml-Lib
sudo apt install --yes libfyaml-dev
sudo apt install --yes libfyaml-utils
sudo apt install --yes libfyaml0

### ################################
### Installing C Libraries
### ################################

# USB
sudo apt install --yes libusb-dev
# GLFW
sudo apt install --yes libglfw3-dev
sudo apt install --yes libglfw3-doc
# SDL3
sudo apt install --yes libsdl3-dev
sudo apt install --yes libsdl3-doc
sudo apt install --yes libsdl3-image-dev
sudo apt install --yes libsdl3-image-doc
sudo apt install --yes libsdl3-ttf-dev
sudo apt install --yes libsdl3-ttf-doc
# SFML
sudo apt install --yes libsfml-dev
sudo apt install --yes libsfml-doc
sudo apt install --yes libcsfml-dev
sudo apt install --yes libcsfml-doc
# OpenGL
sudo apt install --yes libglm-dev
sudo apt install --yes libglm-doc
sudo apt install --yes libcglm-dev
sudo apt install --yes libcglm-doc
sudo apt install --yes libglew-dev
sudo apt install --yes opengl-4-man-doc
# OpenAL
sudo apt install --yes libopenal-dev
# OpenCL
sudo apt install --yes opencl-headers
sudo apt install --yes ocl-icd-opencl-dev
sudo apt install --yes libclc-19
sudo apt install --yes opencl-1.2-man-doc
# FreeType
sudo apt install --yes libfreetype-dev

### ################################
### Installing Frameworks
### ################################

# Install Love2D
sudo apt install --yes love

### ################################################################################################################################

### ################################
### Installing LSP Servers
### ################################

# Formatter LSP
go install golang.org/x/tools/gopls@latest
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
# Mermaid
sudo npm install --global mermaid-cli@latest
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
### Mermaid CLI
### ################################

cat << 'EOF' | tee "${HOME}/.mermaid-puppeteer-config.json" > "/dev/null"
{
	"executablePath": "/usr/bin/google-chrome-stable",
	"args": ["--no-sandbox"]
}
EOF

cat << 'EOF' | tee "${HOME}/.mermaid-theme-config.json" > "/dev/null"
{
	"theme": "dark",
	"themeVariables": {
		"fontFamily": "\"JetBrainsMonoNL Nerd Font Mono\", Monospace, Consolas",
		"fontSize": "24px",
		"darkMode": true
	}
}
EOF

### ################################################################################################################################

### ################################
### Installing Window Editor
### ################################

# VS Code
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

# Zed
curl -f https://zed.dev/install.sh | bash
cat << 'EOF' | tee "${HOME}/.local/bin/zed-nvc" > "/dev/null"
#!/usr/bin/bash
DRI_PRIME=1 ${HOME}/.local/bin/zed "$@"
EOF
chmod +x "${HOME}/.local/bin/zed-nvc"

# Geany
sudo apt install --yes geany
cat << 'EOF' | tee "${HOME}/.local/bin/geany" > "/dev/null"
#!/usr/bin/bash
GTK_THEME=Adwaita:dark /usr/bin/geany "$@"
EOF
chmod +x "${HOME}/.local/bin/geany"

# Google Antigravity OSS
sudo mkdir -p "/etc/apt/keyrings"
curl -fsSL "https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg" | \
sudo gpg --dearmor --yes -o "/etc/apt/keyrings/antigravity-repo-key.gpg"
cat << 'EOF' | sudo tee "/etc/apt/sources.list.d/antigravity.list" > "/dev/null"
deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main
EOF
sudo apt update
sudo apt install --yes antigravity

# Alias Antigravity IDE
cat << 'EOF' | sudo tee "/usr/bin/ant" > "/dev/null"
#!/usr/bin/sh
antigravity "$@"
EOF
sudo chmod +x "/usr/bin/ant"

### ################################
### Installing Terminal Editor
### ################################

sudo apt install --yes mg
sudo apt install --yes micro
sudo apt install --yes hx
sudo apt install --yes neovim
sudo apt install --yes vim
sudo apt install --yes emacs

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
cat << 'EOF' | tee "${HOME}/.local/bin/hx" > "/dev/null"
#!/usr/bin/bash
/usr/bin/hx "$@"
echo -e -n "\x1b[\x30 q"
EOF
chmod +x "${HOME}/.local/bin/hx"

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
### Installing Theme in Geany
### ################################

# https://www.geany.org/
mkdir -p "${HOME}/.config/geany/colorschemes"
cd "${HOME}/.config/geany/colorschemes"
wget "https://raw.githubusercontent.com/geany/geany-themes/master/colorschemes/one-dark.conf"
cd ~

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

### ################################
### Installing GUI Tools
### ################################

# Wireshark
sudo apt install --yes wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -aG wireshark "$(id -un)"
newgrp wireshark
cat << 'EOF' | sudo tee "/usr/local/bin/wireshark" > "/dev/null"
#!/bin/bash
QT_QPA_PLATFORMTHEME="" /usr/bin/wireshark "$@"
EOF
sudo chmod +x "/usr/local/bin/wireshark"
# DBeaver
sudo wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee "/etc/apt/sources.list.d/dbeaver.list" > "/dev/null"
sudo apt update
sudo apt install --yes dbeaver-ce
# Chrome
curl -fSsL "https://dl.google.com/linux/linux_signing_key.pub" | sudo gpg --dearmor | sudo tee "/usr/share/keyrings/google-chrome.gpg" > "/dev/null"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee "/etc/apt/sources.list.d/google-chrome.list"
sudo apt update
sudo apt install --yes google-chrome-stable
# Edge
curl -fSsL "https://packages.microsoft.com/keys/microsoft.asc" | sudo gpg --dearmor | sudo tee "/usr/share/keyrings/microsoft-edge.gpg" > "/dev/null"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee "/etc/apt/sources.list.d/microsoft-edge.list"
sudo apt update
sudo apt install --yes microsoft-edge-stable
# GitHub
flatpak install -y flathub io.github.shiftey.Desktop
flatall io.github.shiftey.Desktop
# pgAdmin
flatpak install -y flathub org.pgadmin.pgadmin4
flatall org.pgadmin.pgadmin4
# Office
flatpak install -y flathub org.onlyoffice.desktopeditors
flatall org.onlyoffice.desktopeditors

### ################################################################################################################################
