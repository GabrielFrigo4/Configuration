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
### Install Container Essential
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
### Install Internet Essential
### ################################

sudo apt install --yes iptables-persistent
sudo netfilter-persistent save

### ################################
### Install Build Essential
### ################################

sudo apt install --yes build-essential
sudo apt install --yes cmake
sudo apt install --yes make

### ################################
### Install Clang Essential
### ################################

sudo apt install --yes clang
sudo apt install --yes libclang-dev

### ################################
### Install Musl Essential
### ################################

sudo apt install --yes musl
sudo apt install --yes musl-dev
sudo apt install --yes musl-tools

### ################################
### Install Git Essential
### ################################

sudo apt install --yes git
sudo apt install --yes git-credential-oauth
sudo apt install --yes gh

GCM_VER="$(curl -Ls -o "/dev/null" -w %{url_effective} "https://github.com/git-ecosystem/git-credential-manager/releases/latest" | awk -F/ '{print $(NF)}' | sed 's/^v//')"
wget -O gcm.deb "https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VER}/gcm-linux-x64-${GCM_VER}.deb"
sudo apt install --yes "./gcm.deb"
rm "./gcm.deb"

rm "${HOME}/.gitconfig"
git config --global credential.helper "!gh auth git-credential"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

### ################################################################################################################################

### ################################
### Setup Emacs
### ################################

sudo apt install --yes mg

### ################################
### Setup Micro
### ################################

sudo apt install --yes micro
git clone "https://github.com/dracula/micro.git"
mkdir -p "${HOME}/.config/micro/colorschemes"
cp "micro/dracula.micro" "${HOME}/.config/micro/colorschemes/dracula.micro"
sudo rm -f -r micro
cat << 'EOF' | tee "${HOME}/.config/micro/settings.json" > "/dev/null"
{
	"colorscheme": "dracula"
}
EOF

### ################################
### Setup Vim
### ################################

sudo apt install --yes vim
cat << 'EOF' | tee "${HOME}/.vimrc" | sudo tee "/root/.vimrc" > "/dev/null"
syn on|filetype plugin indent on
se nocp nu rnu noet sts=4 sw=4 ts=4 bs=2 ww+=<,>,h,l,[,]
let &t_SI="\<Esc>[5 q"|let &t_SR="\<Esc>[3 q"|let &t_EI="\<Esc>[1 q"
EOF

### ################################
### Setup Shell and Bash
### ################################

curl -fsSL "https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh" | bash -s -- --unattended
curl -fsSL "https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh" | sudo bash -s -- --unattended

sed -i 's/OSH_THEME=".*"/OSH_THEME=""/' "${HOME}/.bashrc"
sudo sed -i 's/OSH_THEME=".*"/OSH_THEME=""/' "/root/.bashrc"

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
export PATH=$(printf "%s" "${PATH}" | awk -v RS=: -v ORS=: '!a[$(0)]++' | sed 's/:$//')

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
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh="which"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade -y"
alias upall="upapt"

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################
### Installing Zsh
### ################################

sudo apt install --yes zsh
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | zsh -s -- --unattended
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | sudo zsh -s -- --unattended
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
export PATH=$(printf "%s" "${PATH}" | awk -v RS=: -v ORS=: '!a[$(0)]++' | sed 's/:$//')

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
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh="which"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade -y"
alias upall="upapt"

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################################################################################################################
