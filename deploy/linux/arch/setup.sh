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

rm "${HOME}/.gitconfig"
git config --global credential.helper "!gh auth git-credential"
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
### Installing Connection Tools
### ################################

sudo pacman --needed --noconfirm -S bluez-utils
sudo pacman --needed --noconfirm -S iwd

### ################################
### Installing Build System Tools
### ################################

sudo pacman --needed --noconfirm -S make
sudo pacman --needed --noconfirm -S cmake
sudo pacman --needed --noconfirm -S ninja
sudo pacman --needed --noconfirm -S meson

### ################################
### Installing Build Docs Tools
### ################################

sudo pacman --needed --noconfirm -S doxygen

### ################################
### Installing Bootable Tools
### ################################

sudo pacman --needed --noconfirm -S ventoy

### ################################
### Setup Workspace (User)
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

# Dual Shock 4
cat << 'EOF' | sudo tee "/etc/udev/rules.d/99-ds4.rules" > "/dev/null"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
EOF

### ################################################################################################################################

### ################################
### Installing Pacman Contrib
### ################################

sudo pacman --needed --noconfirm -S  pacman-contrib

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
alias show="dolphin ."
alias ds="disown"
alias brw="lynx -use_mouse=on -nobrowse=on -nopause=on -show_cursor=off"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Manual ALIAS
alias wman="win-man"
alias uman="unix-man"
alias mandoc="unix-man"
# Management ALIAS
alias upyay="yay --noconfirm -Syu"
alias upflat="flatpak update -y"
alias upsh="omz update"
alias upall="upsh && upyay && upflat"
alias backusb="./\"#BackupAll\""
alias yays="yay -Ss"
alias yayi="yay -S"
alias yayr="yay -Rcns"
alias yayu="yay -Syu"
alias pac="pacman"
alias pacs="pacman -Ss"
alias paci="pacman -S"
alias pacr="pacman -Rcns"
alias pacu="pacman -Syu"
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
alias ok="nohup kate . &> \"/dev/null\" &"
alias og="nohup geany . &> \"/dev/null\" &"
alias oc="code ."
alias ocm="codium ."
alias oa="antigravity ."
alias oz="zed ."
alias on="nvim ."
alias ov="vim ."
alias ant="antigravity"
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

yay --needed --noconfirm -S zsh
sudo chsh -s "$(which zsh)" "$(id -un)"
sudo chsh -s "$(which zsh)" "root"

yay --needed --noconfirm -S zsh-theme-powerlevel10k
cat << 'EOF' | tee -a "${HOME}/.zshrc" | sudo tee -a "/root/.zshrc" > "/dev/null"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
EOF
p10k configure

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
alias show="dolphin ."
alias ds="disown"
alias brw="lynx -use_mouse=on -nobrowse=on -nopause=on -show_cursor=off"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Manual ALIAS
alias wman="win-man"
alias uman="unix-man"
alias mandoc="unix-man"
# Management ALIAS
alias upyay="yay --noconfirm -Syu"
alias upflat="flatpak update -y"
alias upsh="omz update"
alias upall="upsh && upyay && upflat"
alias backusb="./\"#BackupAll\""
alias yays="yay -Ss"
alias yayi="yay -S"
alias yayr="yay -Rcns"
alias yayu="yay -Syu"
alias pac="pacman"
alias pacs="pacman -Ss"
alias paci="pacman -S"
alias pacr="pacman -Rcns"
alias pacu="pacman -Syu"
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
alias ok="nohup kate . &> \"/dev/null\" &"
alias og="nohup geany . &> \"/dev/null\" &"
alias oc="code ."
alias ocm="codium ."
alias oa="antigravity ."
alias oz="zed ."
alias on="nvim ."
alias ov="vim ."
alias ant="antigravity"
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

$env.config.buffer_editor = "code";
$env.config.show_banner = false;

$env.PATH = ($env.PATH | append $"($env.HOME)/.platformio/penv/bin");
$env.PATH = ($env.PATH | append $"($env.HOME)/.cargo/bin");

$env.PATH = ($env.PATH 
	| split row (char esep)
	| prepend ($env.HOME | path join .local bin)
	| prepend ($env.HOME | path join .cargo bin)
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
alias brw = lynx -use_mouse=on -nobrowse=on -nopause=on -show_cursor=off;
alias mmdc = mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b "#191919" -s 4;
# Manual ALIAS
alias wman = win-man;
alias uman = unix-man;
alias mandoc = unix-man;
# Management ALIAS
alias backusb = ./"#BackupAll";
alias yays = yay -Ss;
alias yayi = yay -S;
alias yayr = yay -Rcns;
alias yayu = yay -Syu;
alias pac = pacman;
alias pacs = pacman -Ss;
alias paci = pacman -S;
alias pacr = pacman -Rcns;
alias pacu = pacman -Syu;
# Goto ALIAS
alias desk = cd "~/Área de trabalho";
alias down = cd ~/Downloads;
# Emacs ALIAS
alias ek = pkill emacs;
alias es = emacs --daemon;
alias ec = emacsclient --create-frame --alternate-editor "";
alias oe = emacsclient --create-frame --alternate-editor "" .;
# Code Editors ALIAS
alias ok = kate .;
alias og = geany .;
alias oc = code .;
alias ocm = codium .;
alias oa = antigravity .;
alias oz = zed .;
alias on = nvim .;
alias ov = vim .;
alias ant = antigravity;

### ################################
### SHELL FUNCTIONS
### ################################

# Management FUNC
def upflat [] { flatpak update -y }
def upyay [] { yay --noconfirm -Syu };
def upall [] { upyay; upflat };

# Emacs FUNC
def er [] { ek; es };

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
### Setup Konsole Profiles
### ################################

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Bash.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breath
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/bash
Name=Bash
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Zsh.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breath
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/zsh
Name=Zsh
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Nushell.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breath
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/nu
Name=Nushell
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

cat << 'EOF' | tee "${HOME}/.local/share/konsole/PowerShell.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breath
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
# WordMode=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/pwsh
Name=PowerShell
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

### ################################################################################################################################

### ################################
### Setup Real Server
### ################################

chmod 0600 "${FRIGO_SERVER_KEY}"
cat << 'EOF' | sudo tee "/usr/local/bin/frigo-server" > "/dev/null"
#!/usr/bin/zsh
source "${HOME}/.vault/servers/servers.env"
ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
EOF
sudo chmod +x "/usr/local/bin/frigo-server"

chmod 0600 "${ORBS_SERVER_KEY}"
cat << 'EOF' | sudo tee "/usr/local/bin/orbs-server" > "/dev/null"
#!/usr/bin/zsh
source "${HOME}/.vault/servers/servers.env"
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
### Installing System Libraries
### ################################

# Installing Sys-Lib
yay --needed --noconfirm -S libxml++
yay --needed --noconfirm -S libvterm
yay --needed --noconfirm -S ctags
yay --needed --noconfirm -S gtk3 gtk4
yay --needed --noconfirm -S notcurses
yay --needed --noconfirm -S ncurses
yay --needed --noconfirm -S jansson
# Installing Dev-Lib
yay --needed --noconfirm -S bluez-libs
yay --needed --noconfirm -S minizip-ng
yay --needed --noconfirm -S minizip
yay --needed --noconfirm -S zlib-ng
yay --needed --noconfirm -S zlib
# Installing Ssl-Lib
yay --needed --noconfirm -S libressl
yay --needed --noconfirm -S openssl
yay --needed --noconfirm -S libsodium
yay --needed --noconfirm -S gnupg

# Installing Dev-Lib (64 bits)
yay --needed --noconfirm -S gcc-libs
yay --needed --noconfirm -S xcb-util
yay --needed --noconfirm -S alsa-lib
yay --needed --noconfirm -S cairo
# Installing Dev-Lib (32 bits)
yay --needed --noconfirm -S lib32-gcc-libs
yay --needed --noconfirm -S lib32-xcb-util
yay --needed --noconfirm -S lib32-alsa-lib
yay --needed --noconfirm -S lib32-cairo

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
# USB
yay --needed --noconfirm -S libserialport
yay --needed --noconfirm -S libusb
yay --needed --noconfirm -S hidapi
# ZMQ
yay --needed --noconfirm -S zeromq
yay --needed --noconfirm -S cppzmq
# GLFW
yay --needed --noconfirm -S glfw
# SDL3
yay --needed --noconfirm -S sdl3
yay --needed --noconfirm -S sdl3_image
yay --needed --noconfirm -S sdl3_sound
yay --needed --noconfirm -S sdl3_mixer
yay --needed --noconfirm -S sdl3_ttf
yay --needed --noconfirm -S sdl3_shadercross
# SFML
yay --needed --noconfirm -S sfml
yay --needed --noconfirm -S csfml
# OpenGL
yay --needed --noconfirm -S glm
yay --needed --noconfirm -S cglm
yay --needed --noconfirm -S glew
yay --needed --noconfirm -S opengl-man-pages
# OpenAL
yay --needed --noconfirm -S openal
# OpenCL
yay --needed --noconfirm -S opencl-icd-loader
yay --needed --noconfirm -S libclc
# FreeType
yay --needed --noconfirm -S freetype2
# Plot
yay --needed --noconfirm -S cairo
# Graph
yay --needed --noconfirm -S igraph

### ################################
### Installing Haskell Libraries
### ################################

# Install Glasgow Haskell
yay --needed --noconfirm -S ghc-static
yay --needed --noconfirm -S ghc-libs

### ################################
### Installing Python Libraries
### ################################

# Tool
yay --needed --noconfirm -S python-pytooling
yay --needed --noconfirm -S python-pyautogui
yay --needed --noconfirm -S python-pillow
# Hack
yay --needed --noconfirm -S python-pwntools
# LLM
yay --needed --noconfirm -S python-google-genai
# Document
yay --needed --noconfirm -S python-weasyprint
# Math
yay --needed --noconfirm -S python-matplotlib
yay --needed --noconfirm -S python-cairo
yay --needed --noconfirm -S python-pulp
# Graph
yay --needed --noconfirm -S python-networkx
yay --needed --noconfirm -S python-igraph
# Net
yay --needed --noconfirm -S python-websockets
yay --needed --noconfirm -S python-pystun3
yay --needed --noconfirm -S python-flask

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
yay --needed --noconfirm -S musl
yay --needed --noconfirm -S bear
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"
# GPU
yay --needed --noconfirm -S adaptivecpp
# Zig
yay --needed --noconfirm -S zig
# Rust
yay --needed --noconfirm -S rustup
rustup update
rustup default stable
rustup toolchain install stable
# Go
yay --needed --noconfirm -S go # or 'gcc-go'
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
yay --needed --noconfirm -S nelua-git
# Lisp
yay --needed --noconfirm -S sbcl

### ################################
### Installing GCC Frontends
### ################################

# Fortran
yay --needed --noconfirm -S gcc-fortran
# Rust
yay --needed --noconfirm -S gcc-rust
# Ada
yay --needed --noconfirm -S gcc-ada
# Go
yay --needed --noconfirm -S gcc-go # or 'go'
# D
yay --needed --noconfirm -S gcc-d

### ################################################################################################################################

### ################################
### Installing LSP Servers
### ################################

# Formatter LSP
go install golang.org/x/tools/gopls@latest
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
yay --needed --noconfirm -S valgrind
# Hacking Tools
yay --needed --noconfirm -S ropgadget
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
# Embedded Tools
yay --needed --noconfirm -S platformio-core
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
# Pandoc
yay --needed --noconfirm -S pandoc-plot
yay --needed --noconfirm -S pandoc-cli
# Convert
yay --needed --noconfirm -S imagemagick
yay --needed --noconfirm -S ffmpeg
# OCR
yay --needed --noconfirm -S ocrs
yay --needed --noconfirm -S gocr
yay --needed --noconfirm -S ocrad
yay --needed --noconfirm -S tesseract
yay --needed --noconfirm -S tesseract-data-eng
yay --needed --noconfirm -S tesseract-data-por
yay --needed --noconfirm -S ocrmypdf
# Hardware
yay --needed --noconfirm -S esptool
# Media
yay --needed --noconfirm -S yt-dlp
yay --needed --noconfirm -S ytui
yay --needed --noconfirm -S ani-cli
# Fetch
yay --needed --noconfirm -S fastfetch
# Security
yay --needed --noconfirm -S dirb

### ################################################################################################################################

### ################################
### Installing JavaScript Packages
### ################################

# Software
yay --needed --noconfirm -S nodejs-localtunnel

### ################################################################################################################################

### ################################
### Installing Python Packages
### ################################

# Package Manager
yay --needed --noconfirm -S python-venv
yay --needed --noconfirm -S python-pip
yay --needed --noconfirm -S python-pipx
yay --needed --noconfirm -S uv

# Cython
yay --needed --noconfirm -S cython

### ################################################################################################################################

### ################################
### Installing Lua Packages
### ################################

# Package Manager
yay --needed --noconfirm -S luarocks

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

yay --needed --noconfirm -S emacs
yay --needed --noconfirm -S neovim
yay --needed --noconfirm -S gvim
yay --needed --noconfirm -S helix
yay --needed --noconfirm -S micro
yay --needed --noconfirm -S mg

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

### ################################
### Installing General Software
### ################################

# Office
yay --needed --noconfirm -S libreoffice-still
yay --needed --noconfirm -S onlyoffice-desktopeditors
# Web Browser
yay --needed --noconfirm -S microsoft-edge-stable
yay --needed --noconfirm -S google-chrome
# Communication
yay --needed --noconfirm -S discord
yay --needed --noconfirm -S zoom
# Conversor
yay --needed --noconfirm -S handbrake
# Computation
yay --needed --noconfirm -S scilab
# Drawing
yay --needed --noconfirm -S gimp
yay --needed --noconfirm -S krita
yay --needed --noconfirm -S inkscape
yay --needed --noconfirm -S libresprite
yay --needed --noconfirm -S blender
# Screen Recorder
yay --needed --noconfirm -S obs-studio
# Viewer
yay --needed --noconfirm -S feh
# CAD
yay --needed --noconfirm -S freecad
# Buds Client
yay --needed --noconfirm -S galaxybudsclient-bin
# Flash
yay --needed --noconfirm -S etcher-bin
# LaTeX / TeX
yay --needed --noconfirm -S texworks
# VMWare
yay --needed --noconfirm -S vmware-keymaps
yay --needed --noconfirm -S vmware-workstation
# QEMU
yay --needed --noconfirm -S qemu-full
# RDP
yay --needed --noconfirm -S remmina
yay --needed --noconfirm -S freerdp

### ################################
### Installing Development Software
### ################################

# https://github.com/horsicq
yay --needed --noconfirm -S xelfviewer-bin
yay --needed --noconfirm -S xpeviewer-bin
yay --needed --noconfirm -S xmachoviewer-bin
yay --needed --noconfirm -S xapkdetector-bin
# Reverse Engineering
yay --needed --noconfirm -S ghidra
# Debugger
yay --needed --noconfirm -S gf2-git
# Network
yay --needed --noconfirm -S wireshark-cli
yay --needed --noconfirm -S wireshark-qt
sudo usermod -aG wireshark "$(id -un)"
newgrp wireshark
cat << 'EOF' | sudo tee "/usr/local/bin/wireshark" > "/dev/null"
#!/bin/bash
QT_QPA_PLATFORMTHEME="" /usr/bin/wireshark "$@"
EOF
sudo chmod +x "/usr/local/bin/wireshark"
# Database
yay --needed --noconfirm -S dbeaver
# Game Engine
yay --needed --noconfirm -S unityhub
yay --needed --noconfirm -S godot
# Arduino
yay --needed --noconfirm -S arduino-ide-bin
yay --needed --noconfirm -S arduino-cli
# Google
yay --needed --noconfirm -S gdown
# Hardware (CPU)
yay --needed --noconfirm -S digital
yay --needed --noconfirm -S openfpgaloader
yay --needed --noconfirm -S quartus-free
yay --needed --noconfirm -S gtkwave
yay --needed --noconfirm -S ghdl

### ################################################################################################################################

### ################################
### Installing Development Software
### ################################

# GitHub
yay --needed --noconfirm -S github-desktop-bin

# GitKraken
yay --needed --noconfirm -S gitkraken-cli-bin
yay --needed --noconfirm -S gitkraken

# Git Credential
yay --needed --noconfirm -S git-credential-manager-bin
git-credential-manager configure

# Firebase
curl -sL "https://firebase.tools" | sudo upgrade=true bash
yay --needed --noconfirm -S firebase-tools-bin

### ################################
### Installing KVM/QEMU
### ################################

# Hypervisor
yay --needed --noconfirm -S qemu-desktop

# Daemon
yay --needed --noconfirm -S libvirt

# Rede Virtual
yay --needed --noconfirm -S dnsmasq
yay --needed --noconfirm -S iptables-nft 

# Firmware
yay --needed --noconfirm -S edk2-ovmf

# Interface Gráfica
yay --needed --noconfirm -S virt-manager
yay --needed --noconfirm -S virt-viewer

# Configuração e Ativação
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$(id -un)"
sudo virsh --connect qemu:///system net-autostart default
sudo virsh --connect qemu:///system net-start default

### ################################
### Mermaid CLI
### ################################

yay --needed --noconfirm -S mermaid-cli

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

### ################################
### Installing pgAdmin4
### ################################

flatpak install -y flathub org.pgadmin.pgadmin4
flatall org.pgadmin.pgadmin4

sudo mkdir -p "/var/lib/pgadmin"
sudo mkdir -p "/var/log/pgadmin"
sudo chown "$(id -un)" "/var/lib/pgadmin"
sudo chown "$(id -un)" "/var/log/pgadmin"

cd ~
python -m venv pgadmin4
source ~/pgadmin4/bin/activate
cd pgadmin4
pip install pgadmin4
cd ~

cat << 'EOF' | tee "${HOME}/.local/bin/pgadmin4" > "/dev/null"
#!/usr/bin/sh
source ~/pgadmin4/bin/activate
pgadmin4 "$@"
EOF
chmod +x "${HOME}/.local/bin/pgadmin4"

### ################################
### Installing Code Editors
### ################################

# https://www.geany.org/
yay --needed --noconfirm -S geany
mkdir -p "${HOME}/.config/geany/colorschemes"
cd "${HOME}/.config/geany/colorschemes"
wget "https://raw.githubusercontent.com/geany/geany-themes/master/colorschemes/one-dark.conf"
cd ~

# https://zed.dev/
curl -f https://zed.dev/install.sh | sh
yay --needed --noconfirm -S zed

# Proprietary Licensed
yay --needed --noconfirm -S visual-studio-code-bin # or 'code'
# MIT-Licensed => Source
yay --needed --noconfirm -S vscodium-bin
# MIT-Licensed => Binary
yay --needed --noconfirm -S code # or 'visual-studio-code-bin'

# Google Antigravity OSS
yay --needed --noconfirm -S antigravity
yay --needed --noconfirm -S antigravity-ide

# Alias Antigravity IDE
cat << 'EOF' | sudo tee "/usr/bin/ant" > "/dev/null"
#!/usr/bin/sh
antigravity-ide "$@"
EOF
sudo chmod +x "/usr/bin/ant"

### ################################
### Installing Games
### ################################

# Steam
yay --needed --noconfirm -S steam

### ################################################################################################################################
