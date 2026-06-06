#!/usr/bin/sh

################################################################################################

### ################################
### System and Hostname
### ################################


OLD="$(hostname)"
NEW="${OLD/"QID"/"QIN"}"
hostnamectl set-hostname "${NEW}"
sed -i "s/${OLD}/${NEW}/g" "/etc/hosts"


### ################################
### SUDO and DOAS
### ################################


# SUDO Refresh
sudo -v

# Install DOAS
sudo apt install --yes doas
cat << 'EOF' | sudo tee "/etc/doas.conf" > "/dev/null"
permit persist :sudo
EOF
sudo chmod 0440 "/etc/doas.conf"


### ################################
### APT, Snap and Flatpak
### ################################


# Update APT
sudo apt update
sudo apt upgrade --yes

# Refresh Snap
sudo snap refresh

# Setup Flatpak
sudo apt update
sudo apt install --yes flatpak
flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

# Setup Homebrew
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Remove Ubuntu Pro Message
sudo rm "/etc/apt/apt.conf.d/20apt-esm-hook.conf"
sudo touch "/etc/apt/apt.conf.d/20apt-esm-hook.conf"


### ################################
### Git
### ################################


# Install Git
sudo apt install --yes git

# Setup Global Git
config_global_git() {
	rm "${HOME}/.gitconfig"
	git config --global credential.helper "!gh auth git-credential"
	git config --global user.email "${GIT_EMAIL}"
	git config --global user.name "Gabriel Frigo"
	git config --global init.defaultBranch "main"
	git config --global pull.rebase false
	git config --global color.ui auto
}
config_global_git

# Setup Local Git
config_local_git() {
	git config --local user.email "gabriel.frigo@qitech.com.br"
	git config --local user.name "Gabriel Frigo"
}

# Install GC-AUTH
GCAUTH_VER="$(curl -Ls -o "/dev/null" -w %{url_effective} "https://github.com/hickford/git-credential-oauth/releases/latest" | awk -F/ '{print $(NF)}' | sed 's/^v//')"
wget -qO "/tmp/gc-auth.tar.gz" "https://github.com/hickford/git-credential-oauth/releases/download/v${GCAUTH_VER}/git-credential-oauth_${GCAUTH_VER}_linux_amd64.tar.gz"
sudo rm -rf "/opt/gc-auth"
sudo mkdir -p "/opt/gc-auth"
sudo tar -C "/opt/gc-auth" -xzf "/tmp/gc-auth.tar.gz"
sudo ln -sf "/opt/gc-auth/git-credential-oauth" "/usr/local/bin/git-credential-oauth"
rm "/tmp/gc-auth.tar.gz"

# Install GCM
GCM_VER="$(curl -Ls -o "/dev/null" -w %{url_effective} "https://github.com/git-ecosystem/git-credential-manager/releases/latest" | awk -F/ '{print $(NF)}' | sed 's/^v//')"
wget -O gcm.deb "https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VER}/gcm-linux-x64-${GCM_VER}.deb"
sudo apt install --yes "./gcm.deb"
rm "./gcm.deb"

# Install GitHub-CLI
sudo apt install --yes gh
gh auth login
gh auth setup-git

# Clone QI Tech
git config --global alias.qiclone '!f() { git clone -c user.email="gabriel.frigo@qitech.com.br" -c user.name="Gabriel Frigo" "$@"; }; f'

### ################################
### VPN
### ################################


# Install OpenVPN
sudo apt install --yes network-manager-openvpn
sudo apt install --yes network-manager-openvpn-gnome
sudo apt install --yes network-manager-openconnect
sudo apt install --yes network-manager-openconnect-gnome


### ################################
### CLI
### ################################


# Install Eza
sudo apt install --yes gpg
sudo mkdir -p "/etc/apt/keyrings"
wget -qO- "https://raw.githubusercontent.com/eza-community/eza/main/deb.asc" | sudo gpg --dearmor -o "/etc/apt/keyrings/gierens.gpg"
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee "/etc/apt/sources.list.d/gierens.list" > "/dev/null"
sudo apt update
sudo apt install --yes eza
sudo ln -sf "/usr/bin/eza" "/usr/bin/exa"

# Install RipGrep
sudo apt install --yes ripgrep

# Install BatCat
sudo apt install --yes bat
cat << 'EOF' | sudo tee "/usr/local/bin/bat" > "/dev/null"
#!/bin/bash
batcat "$@"
EOF
sudo chmod +x "/usr/local/bin/bat"

# Install Fd-Find
sudo apt install --yes fd-find
cat << 'EOF' | sudo tee "/usr/local/bin/fd" > "/dev/null"
#!/bin/bash
fdfind "$@"
EOF
sudo chmod +x "/usr/local/bin/fd"

# Install LaTeX
sudo apt install --yes texlive-xetex
sudo apt install --yes texlive-latex-extra
sudo apt install --yes texlive-lang-portuguese

# Install Pandoc
sudo apt install --yes pandoc

# Install Micro
sudo apt install --yes micro


################################################################################################

### ################################
### Gnome Softwares
### ################################


# Install Tweaks
sudo apt install --yes gnome-tweaks

# Install Configuration
sudo apt install --yes dconf-editor

# Install Clipboard
sudo apt install --yes wl-clipboard
sudo apt install --yes xclip
sudo apt install --yes xsel


### ################################
### Gnome Terminal
### ################################


# Install Gnome Terminal
sudo apt install --yes gnome-terminal

# Setup Gnome Terminal
sudo apt remove --yes nautilus-extension-gnome-terminal


### ################################
### Gnome Console
### ################################


# Install Gnome Terminal
sudo apt install --yes gnome-console

# Setup Gnome Terminal
sudo apt install --yes nautilus-extension-gnome-console


### ################################
### Tilix
### ################################


# Install Tilix
sudo apt install --yes tilix

# Setup Tilix
sudo update-alternatives --install "/usr/bin/x-terminal-emulator" "x-terminal-emulator" "/usr/bin/tilix" 255
sudo update-alternatives --set "x-terminal-emulator" "/usr/bin/tilix"


################################################################################################

### ################################
### Google Chrome
### ################################


# Install Google Chrome
sudo apt install --yes curl apt-transport-https gdebi
wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo gdebi google-chrome*
rm "google-chrome-stable_current_amd64.deb"


### ################################
### Build Essential
### ################################


# Install Build Essential
sudo add-apt-repository --yes "ppa:ubuntu-toolchain-r/test"
sudo apt update
sudo apt install --yes build-essential

# Update Build Essential
GCC_VER="13"
sudo apt install --yes "gcc-$GCC_VER"
sudo apt install --yes "g++-$GCC_VER"
sudo update-alternatives --install "/usr/bin/gcc" gcc "/usr/bin/gcc-$GCC_VER" 100 \
	--slave "/usr/bin/g++" g++ "/usr/bin/g++-$GCC_VER" \
	--slave "/usr/bin/c++" c++ "/usr/bin/c++-$GCC_VER" \
	--slave "/usr/bin/cpp" cpp "/usr/bin/cpp-$GCC_VER" \
	--slave "/usr/bin/gcov" gcov "/usr/bin/gcov-$GCC_VER" \
	--slave "/usr/bin/gcc-ar" gcc-ar "/usr/bin/gcc-ar-$GCC_VER" \
	--slave "/usr/bin/gcc-nm" gcc-nm "/usr/bin/gcc-nm-$GCC_VER" \
	--slave "/usr/bin/gcc-ranlib" gcc-ranlib "/usr/bin/gcc-ranlib-$GCC_VER"

# Install GCC Essential
brew install gcc
brew install binutils
BREW_BINUTILS_BIN="$(brew --prefix binutils)/bin"
for TOOL_PATH in "${BREW_BINUTILS_BIN}"/*; do
	TOOL="$(basename "${TOOL_PATH}")"
	ln -sf "${TOOL_PATH}" "${HOME}/.local/bin/${TOOL}"
done
BREW_BIN="$(brew --prefix)/bin"
BREW_GCC_VER="$(ls "${BREW_BIN}" | grep -Eo '^gcc-[0-9]+$' | cut -d- -f2 | sort -n | tail -1)"
BREW_GCC_TARGET="x86_64-pc-linux-gnu"
BREW_GCC_TOOLS=(
	"gcc" "g++" "c++" "cpp" "gcov" "gcc-ar" "gcc-nm" "gcc-ranlib"
	"${BREW_GCC_TARGET}-gcc" "${BREW_GCC_TARGET}-g++" "${BREW_GCC_TARGET}-c++"
	"${BREW_GCC_TARGET}-gcc-ar" "${BREW_GCC_TARGET}-gcc-nm" "${BREW_GCC_TARGET}-gcc-ranlib"
	"${BREW_GCC_TARGET}-gfortran" "${BREW_GCC_TARGET}-gm2"
)
for TOOL in "${BREW_GCC_TOOLS[@]}"; do
	ln -sf "${BREW_BIN}/${TOOL}-${BREW_GCC_VER}" "${HOME}/.local/bin/${TOOL}"
done
ln -sf "${HOME}/.local/bin/gcc" "${HOME}/.local/bin/cc"
ln -sf "${HOME}/.local/bin/g++" "${HOME}/.local/bin/CC"

# Install Clang Essential
sudo apt install --yes clang clang-tools clangd lldb
sudo apt install --yes libclang-dev

# Update Clang Essential
CLANG_VER="$(curl -sL "https://api.github.com/repos/llvm/llvm-project/releases/latest" | grep "tag_name" | cut -d '"' -f 4 | sed 's/llvmorg-//' | cut -d. -f1)"
wget -qO- "https://apt.llvm.org/llvm.sh" | sudo bash -s -- "$CLANG_VER" all
sudo grep -l "apt.llvm.org" /etc/apt/sources.list.d/*.list | \
	xargs sudo sed -i 's/deb http/deb [arch=amd64] http/g'
sudo update-alternatives --install /usr/bin/clang clang "/usr/bin/clang-$CLANG_VER" 100 \
	--slave "/usr/bin/clang++" clang++ "/usr/bin/clang++-$CLANG_VER" \
	--slave "/usr/bin/clangd" clangd "/usr/bin/clangd-$CLANG_VER" \
	--slave "/usr/bin/clang-format" clang-format "/usr/bin/clang-format-$CLANG_VER" \
	--slave "/usr/bin/clang-tidy" clang-tidy "/usr/bin/clang-tidy-$CLANG_VER" \
	--slave "/usr/bin/lldb" lldb "/usr/bin/lldb-$CLANG_VER" \
	--slave "/usr/bin/llvm-config" llvm-config "/usr/bin/llvm-config-$CLANG_VER" \
	--slave "/usr/bin/llvm-ar" llvm-ar "/usr/bin/llvm-ar-$CLANG_VER" \
	--slave "/usr/bin/llvm-nm" llvm-nm "/usr/bin/llvm-nm-$CLANG_VER" \
	--slave "/usr/bin/llvm-ranlib" llvm-ranlib "/usr/bin/llvm-ranlib-$CLANG_VER"
sudo update-alternatives --install "/usr/bin/lld" lld "/usr/bin/lld-$CLANG_VER" 100 \
	--slave "/usr/bin/ld.lld" ld.lld "/usr/bin/ld.lld-$CLANG_VER"

# Install Musl Essential
sudo apt install --yes musl
sudo apt install --yes musl-dev
sudo apt install --yes musl-tools

# Install Rust Essenstial
curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | bash -s -- -y
source "${HOME}/.cargo/env"

# Install NPM Essential
NODEJS_VER="$(curl -sL "https://nodejs.org/dist/index.json" | grep -m1 -o '"version":"v[0-9]*' | sed 's/"version":"v//')"
curl -fsSL "https://deb.nodesource.com/setup_${NODEJS_VER}.x" | sudo -E bash -
sudo apt install --yes nodejs

# Install TreeSitter Essential
cargo install tree-sitter-cli
sudo apt install --yes libtree-sitter-dev

# Install Coreutils Essential
cargo install coreutils
mkdir -p "${HOME}/.local/bin/uutils"
for tool in $(coreutils --list); do
	ln -sf "$(which coreutils)" "${HOME}/.local/bin/uutils/$tool"
done


### ################################
### Library Essential
### ################################


# Install Yaml Essential
sudo apt install --yes libfyaml-dev
sudo apt install --yes libfyaml-utils
sudo apt install --yes libfyaml0


### ################################
### Python3
### ################################


# Update Python
sudo add-apt-repository --yes "ppa:deadsnakes/ppa"
sudo apt update
sudo apt full-upgrade --yes

# Update Pip
python3.10 -m ensurepip --upgrade
python3.10 -m pip install --upgrade pip
python3.10 -m pip install --user dotenv
python3.10 -m pip install --user pytest

# Install Python3.11
sudo apt install --yes python3.11-full
python3.11 -m ensurepip --upgrade
python3.11 -m pip install --upgrade pip
python3.11 -m pip install --user dotenv
python3.11 -m pip install --user pytest

# Install Python3
sudo apt install --yes python3
sudo apt install --yes python3-pip

# Install Python Alias
sudo apt install --yes python-is-python3
sudo apt install --yes pythonpy

# Install PyPy3
sudo apt install --yes pypy3

# Install PyPy
sudo apt install --yes pypy

# Install MyPy
sudo apt install --yes mypy

# Install UV
curl -LsSf https://astral.sh/uv/install.sh | bash


### ################################
### Lua
### ################################


(
	# Temporary Directory
	cd /tmp || exit 1

	# Download Lua
	LUA_VER="$(curl -sL "https://www.lua.org/ftp/" | grep -oE 'lua-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz' | sed -E 's/lua-(.*)\.tar\.gz/\1/' | sort -V | tail -n 1)"
	LUA_SHORT_VER="$(echo "$LUA_VER" | cut -d. -f1,2)"
	wget -O "lua-${LUA_VER}.tar.gz" "http://www.lua.org/ftp/lua-${LUA_VER}.tar.gz"
	tar zxf "lua-${LUA_VER}.tar.gz"
	rm -f "lua-${LUA_VER}.tar.gz"

	# Make Lua
	make -C "lua-${LUA_VER}" all test
	sudo make -C "lua-${LUA_VER}" install
	rm -rf "lua-${LUA_VER}"

	# Download LuaRocks
	LUAROCKS_VER="$(curl -sL "https://api.github.com/repos/luarocks/luarocks/releases/latest" | grep "tag_name" | cut -d '"' -f 4 | sed 's/^v//')"
	wget -O "luarocks.tar.gz" "https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VER}.tar.gz"
	mkdir "luarocks"
	tar zxpf "luarocks.tar.gz" -C "luarocks" --strip-components=1
	rm -f "luarocks.tar.gz"
	cd "luarocks" || exit 1

	# Make LuaRocks
	./configure \
		--with-lua-bin="/usr/local/bin" \
		--with-lua-include="/usr/local/include" \
		--lua-version="${LUA_SHORT_VER}"
	make
	sudo make install

	# Remove Temporary Directory
	cd ..
	rm -rf "luarocks"
)


################################################################################################

### ################################
### Kitty
### ################################


# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | bash /dev/stdin

# Alias Kitty 
cat << 'EOF' | sudo tee "/usr/local/bin/kitty" > "/dev/null"
#!/bin/bash
~/.local/kitty.app/bin/kitty "$@"
EOF
sudo chmod +x "/usr/local/bin/kitty"

# Config Kitty 
mkdir -p "${HOME}/.config/kitty"
cat << 'EOF' | tee "${HOME}/.config/kitty/kitty.conf" > "/dev/null"
### ================================
###  1. Fontes
### ================================
font_family      monospace
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0

### ================================
###  2. Cursor
### ================================
cursor               #FFFFFF
cursor_shape         block
shell_integration    no-cursor
cursor_blink_interval -1

### ================================
###  3. Janela e Interface
### ================================
window_padding_width   4
wayland_titlebar_color background
linux_display_server   auto
tab_bar_style          hidden

### ================================
###  4. Cores do Tema Base
### ================================
background           #1E1E1E
foreground           #D4D4D4
selection_background #3584E4
selection_foreground #FFFFFF

### ================================
###  5. Paleta de Cores
### ================================
color0  #242424
color8  #5E5C64
color1  #C01C28
color9  #F66151
color2  #2EC27E
color10 #33D17A
color3  #F5C211
color11 #F6D32D
color4  #1E78E4
color12 #3584E4
color5  #982176
color13 #C061CB
color6  #0AAEB3
color14 #33C7DE
color7  #D0CFCC
color15 #FFFFFF
EOF


### ################################
### Ptyxis
### ################################


# Install Ptyxis
flatpak install flathub -y app.devsuite.Ptyxis

# Alias Ptyxis 
cat << 'EOF' | sudo tee "/usr/local/bin/ptyxis" > "/dev/null"
#!/bin/bash
if [ "$#" -gt 0 ]; then
	flatpak run app.devsuite.Ptyxis --new-window -- "$@"
else
	flatpak run app.devsuite.Ptyxis --new-window
fi
EOF
sudo chmod +x "/usr/local/bin/ptyxis"

# Setup Ptyxis
sudo apt install --yes python3-nautilus
mkdir -p "${HOME}/.local/share/nautilus-python/extensions"
cat << 'EOF' | tee "${HOME}/.local/share/nautilus-python/extensions/open-ptyxis.py" > "/dev/null"
import subprocess
from gi.repository import Nautilus, GObject

class PtyxisExtension(GObject.GObject, Nautilus.MenuProvider):

	def _get_path(self, file):
		"""Extrai o caminho absoluto do sistema de arquivos."""
		location = file.get_location()
		return location.get_path() if location else None

	def _launch_ptyxis(self, path):
		"""Executa o Flatpak de forma assíncrona."""
		if not path:
			return

		subprocess.Popen(
			[
				"flatpak", 
				"run", 
				"app.devsuite.Ptyxis",
				"--new-window",
				"--working-directory", 
				path
			],
			start_new_session=True
		)

	def menu_activate_cb(self, menu, file):
		path = self._get_path(file)
		self._launch_ptyxis(path)

	def get_background_items(self, window, file):
		item = Nautilus.MenuItem(
			name="Ptyxis::OpenBackground",
			label="Open Ptyxis Here",
			tip="Open Ptyxis in The Selected Folder"
		)
		item.connect("activate", self.menu_activate_cb, file)
		return [item]

	def get_file_items(self, window, files):
		if len(files) != 1:
			return []

		file = files[0]
		if not file.is_directory():
			return []

		item = Nautilus.MenuItem(
			name="Ptyxis::Selection",
			label="Open Ptyxis Here",
			tip="Open Ptyxis in The Selected Folder"
		)
		item.connect("activate", self.menu_activate_cb, file)
		return [item]
EOF
rm "${HOME}/.local/share/nautilus-python/extensions/open-ptyxis.py"


################################################################################################

### ################################
### LibreOffice
### ################################


# Update LibreOffice
sudo add-apt-repository --yes "ppa:libreoffice/ppa"
sudo apt update
sudo apt full-upgrade --yes


### ################################
### OnlyOffice
### ################################


# Add GPG Key
mkdir -p -m 700 "${HOME}/.gnupg"
gpg --no-default-keyring --keyring "gnupg-ring:/tmp/onlyoffice.gpg" --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys CB2DE8E5
chmod 0644 "/tmp/onlyoffice.gpg"
sudo chown root:root "/tmp/onlyoffice.gpg"
sudo mv "/tmp/onlyoffice.gpg" "/usr/share/keyrings/onlyoffice.gpg"

# Add Repository
echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a "/etc/apt/sources.list.d/onlyoffice.list" > "/dev/null"

# Install OnlyOffice
sudo apt update
sudo apt-get install onlyoffice-desktopeditors


### ################################
### Mermaid CLI
### ################################


# Install Mermaid
sudo npm install --global "@mermaid-js/mermaid-cli"

# Setup Mermaid Puppeteer
cat << 'EOF' | tee "${HOME}/.mermaid-puppeteer-config.json" > "/dev/null"
{
	"executablePath": "/usr/bin/google-chrome-stable",
	"args": ["--no-sandbox"]
}
EOF

# Setup Mermaid Theme
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
### GIMP
### ################################


# Install GIMP
sudo apt install --yes gimp


### ################################
### Krita
### ################################


# Install Krita
sudo apt install --yes krita


### ################################
### Inkspace
### ################################


# Install Inkspace
sudo apt install --yes inkscape


################################################################################################

### ################################
### Templates
### ################################


# Empty File
touch "${HOME}/Templates/Empty File"

# Text File
cat << 'EOF' | tee "${HOME}/Templates/Text File.txt" > "/dev/null"
EOF

# Makefile Template
cat << 'EOF' | tee "${HOME}/Templates/Makefile Template" > "/dev/null"
### ================================
### Makefile - Template
### ================================

.PHONY: all help clean

all: help

help:
	@echo "📖 Comandos disponíveis:"
	@printf "  \033[36mmake help\033[0m     📖 Lista comandos disponíveis\n"
	@printf "  \033[36mmake clean\033[0m    🧹 Limpa arquivos temporários\n"

clean:
	@echo "🧹 Limpando..."
EOF

# Makefile Mermaid
cat << 'EOF' | tee "${HOME}/Templates/Makefile Mermaid" > "/dev/null"
### ================================
### Makefile - Mermaid
### ================================

.PHONY: all diagrams help clean

MMDC_CMD         = mmdc
CONFIG_PUPPETEER = "$(HOME)/.mermaid-puppeteer-config.json"
CONFIG_THEME     = "$(HOME)/.mermaid-theme-config.json"
BG_COLOR         = "\#191919"
SCALE            = 4

MMDC_FLAGS = -p $(CONFIG_PUPPETEER) -c $(CONFIG_THEME) -b $(BG_COLOR) -s $(SCALE)

SOURCES = $(wildcard *.mmd)
OBJECTS = $(SOURCES:.mmd=.png)

all: help

help:
	@echo "📖 Comandos disponíveis:"
	@printf "  \033[36mmake diagrams\033[0m 🎨 Gera as imagens PNG dos arquivos Mermaid\n"
	@printf "  \033[36mmake help\033[0m     📖 Lista comandos disponíveis\n"
	@printf "  \033[36mmake clean\033[0m    🧹 Limpa arquivos temporários\n"

diagrams: $(OBJECTS)
	@echo "✅ Todos os diagramas foram gerados com sucesso!"

%.png: %.mmd
	@echo "🎨 Gerando $@ a partir de $<..."
	@$(MMDC_CMD) $(MMDC_FLAGS) -i $< -o $@

clean:
	@echo "🧹 Limpando..."
	@rm -f *.png
EOF

# Makefile Python
cat << 'EOF' | tee "${HOME}/Templates/Makefile Python" > "/dev/null"
### ================================
### Makefile - Python
### ================================

.PHONY: all run install help clean

PYTHON = python3
PIP    = pip
SOURCE = main.py
REQ    = requirements.txt

all: help

help:
	@echo "📖 Comandos disponíveis:"
	@printf "  \033[36mmake run\033[0m      🚀 Executa o script\n"
	@printf "  \033[36mmake install\033[0m  📦 Instala as dependências\n"
	@printf "  \033[36mmake help\033[0m     📖 Lista comandos disponíveis\n"
	@printf "  \033[36mmake clean\033[0m    🧹 Limpa arquivos temporários\n"

run:
	@echo "🚀 Executando..."
	python3 main.py

install:
	@echo "📦 Instalando..."
	pip install -r requirements.txt

clean:
	@echo "🧹 Limpando..."
	@rm -rf "build" "dist" ".pytest_cache" *.egg-info
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@find . -type f -name *.pyc -delete
EOF

# Markdown Document
cat << 'EOF' | tee "${HOME}/Templates/Markdown Document.md" > "/dev/null"
<!-- ================================
	Markdown - Document
================================ -->
EOF

# Mermaid Document
cat << 'EOF' | tee "${HOME}/Templates/Mermaid Document.mmd" > "/dev/null"
%%% ================================
%%% Mermaid - Document
%%% ================================
EOF

# Shell Script
cat << 'EOF' | tee "${HOME}/Templates/Shell Script.sh" > "/dev/null"
#!/usr/bin/sh
EOF

# Python Script
cat << 'EOF' | tee "${HOME}/Templates/Python Script.py" > "/dev/null"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys

def main():
	pass

if __name__ == "__main__":
	main()
EOF

# OpenDocument Writer (.odt/.fodt)
cat << 'EOF' | tee "${HOME}/Templates/Flat XML Writer.fodt" > "/dev/null"
<?xml version="1.0" encoding="UTF-8"?>
<office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" office:mimetype="application/vnd.oasis.opendocument.text">
	<office:body>
		<office:text/>
	</office:body>
</office:document>
EOF
soffice --headless --convert-to odt "${HOME}/Templates/Flat XML Writer.fodt" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Writer.odt" "${HOME}/Templates/OpenDocument Writer.odt"
soffice --headless --convert-to docx "${HOME}/Templates/Flat XML Writer.fodt" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Writer.docx" "${HOME}/Templates/Microsoft Word.docx"
rm "${HOME}/Templates/Flat XML Writer.fodt"

# OpenDocument Calc (.ods/.fods)
cat << 'EOF' | tee "${HOME}/Templates/Flat XML Calc.fods" > "/dev/null"
<?xml version="1.0" encoding="UTF-8"?>
<office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" office:mimetype="application/vnd.oasis.opendocument.spreadsheet">
	<office:body>
		<office:spreadsheet/>
	</office:body>
</office:document>
EOF
soffice --headless --convert-to ods "${HOME}/Templates/Flat XML Calc.fods" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Calc.ods" "${HOME}/Templates/OpenDocument Calc.ods"
soffice --headless --convert-to xlsx "${HOME}/Templates/Flat XML Calc.fods" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Calc.xlsx" "${HOME}/Templates/Microsoft Excel.xlsx"
rm "${HOME}/Templates/Flat XML Calc.fods"

# OpenDocument Impress (.odp/.fodp)
cat << 'EOF' | tee "${HOME}/Templates/Flat XML Impress.fodp" > "/dev/null"
<?xml version="1.0" encoding="UTF-8"?>
<office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" office:mimetype="application/vnd.oasis.opendocument.presentation">
	<office:body>
		<office:presentation/>
	</office:body>
</office:document>
EOF
soffice --headless --convert-to odp "${HOME}/Templates/Flat XML Impress.fodp" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Impress.odp" "${HOME}/Templates/OpenDocument Impress.odp"
soffice --headless --convert-to pptx "${HOME}/Templates/Flat XML Impress.fodp" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Impress.pptx" "${HOME}/Templates/Microsoft PowerPoint.pptx"
rm "${HOME}/Templates/Flat XML Impress.fodp"

# OpenDocument Draw (.odg/.fodg)
cat << 'EOF' | tee "${HOME}/Templates/Flat XML Draw.fodg" > "/dev/null"
<?xml version="1.0" encoding="UTF-8"?>
<office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:drawing="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" office:mimetype="application/vnd.oasis.opendocument.graphics">
	<office:body>
		<office:drawing/>
	</office:body>
</office:document>
EOF
soffice --headless --convert-to odg "${HOME}/Templates/Flat XML Draw.fodg" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Draw.odg" "${HOME}/Templates/OpenDocument Draw.odg"
rm "${HOME}/Templates/Flat XML Draw.fodg"

# OpenDocument Math (.odg/.mml)
cat << 'EOF' | tee "${HOME}/Templates/Flat XML Math.mml" > "/dev/null"
<?xml version="1.0" encoding="UTF-8"?>
<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"/>
EOF
soffice --headless --convert-to odf "${HOME}/Templates/Flat XML Math.mml" --outdir "${HOME}/Templates" > "/dev/null" 2>&1
mv "${HOME}/Templates/Flat XML Math.odf" "${HOME}/Templates/OpenDocument Math.odf"
rm "${HOME}/Templates/Flat XML Math.mml"


### ################################
### Documents
### ################################


# Make Documents
mkdir -p "${HOME}/Documents/1) Git"
mkdir -p "${HOME}/Documents/2) RFC"
mkdir -p "${HOME}/Documents/3) Office"
mkdir -p "${HOME}/Documents/4) Script"

# Make Git
mkdir -p "${HOME}/Documents/1) Git/GitHub"
mkdir -p "${HOME}/Documents/1) Git/GitLab"
mkdir -p "${HOME}/Documents/1) Git/Mirrors"

# Make Office
mkdir -p "${HOME}/Documents/3) Office/Doc"
mkdir -p "${HOME}/Documents/3) Office/Draw"
mkdir -p "${HOME}/Documents/3) Office/Math"
mkdir -p "${HOME}/Documents/3) Office/Sheet"
mkdir -p "${HOME}/Documents/3) Office/Slide"


### ################################
### Gnome Settings
### ################################


TRANSPARENCY_VAL=10
BG_COLOR="'#222222'"
FG_COLOR="'#DEDDDA'"
BOLD_BRIGHT="true"
COLS=88
ROWS=24

G_ID="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')"
G_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${G_ID}/"
gsettings set $G_PATH use-theme-colors false
gsettings set $G_PATH background-transparency-percent "${TRANSPARENCY_VAL}"
gsettings set $G_PATH use-transparent-background true
gsettings set $G_PATH background-color "${BG_COLOR}"
gsettings set $G_PATH foreground-color "${FG_COLOR}"
gsettings set $G_PATH bold-is-bright "${BOLD_BRIGHT}"
gsettings set $G_PATH default-size-columns "${COLS}"
gsettings set $G_PATH default-size-rows "${ROWS}"

T_ID="$(dconf list /com/gexperts/Tilix/profiles/ | head -n1 | tr -d /)"
T_PATH="/com/gexperts/Tilix/profiles/${T_ID}"
dconf write "$T_PATH/use-theme-colors" "false"
dconf write "$T_PATH/background-transparency-percent" "${TRANSPARENCY_VAL}"
dconf write "$T_PATH/background-color" "${BG_COLOR}"
dconf write "$T_PATH/foreground-color" "${FG_COLOR}"
dconf write "$T_PATH/bold-is-bright" "${BOLD_BRIGHT}"
dconf write "$T_PATH/default-size-columns" "${COLS}"
dconf write "$T_PATH/default-size-rows" "${ROWS}"


### ################################
### System Settings
### ################################


# Unbind Show Desktop
gsettings set "org.gnome.desktop.wm.keybindings" "show-desktop" "[]"

# Launch Pasta Pessoal (Home Folder)
gsettings set "org.gnome.settings-daemon.plugins.media-keys" "home" "['<Control><Alt>h']"

# Launch Calculadora (Calculator)
gsettings set "org.gnome.settings-daemon.plugins.media-keys" "calculator" "['<Control><Alt>c']"

# Launch Terminal (Terminal)
gsettings set "org.gnome.settings-daemon.plugins.media-keys" "terminal" "['<Control><Alt>t']"

# Launch Navegador Web (Web Browser)
gsettings set "org.gnome.settings-daemon.plugins.media-keys" "www" "['<Control><Alt>g']"

# Launch Pesquisa (Search)
gsettings set "org.gnome.settings-daemon.plugins.media-keys" "search" "['<Control><Alt>f']"


### ################################
### Custom Settings
### ################################


# Function Create Launcher
create_launcher() {
	local INDEX="${1}"
	local NAME="${2}"
	local COMMAND="${3}"
	local BINDING="${4}"
	local KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${INDEX}/"

	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH" "name" "$NAME"
	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH" "command" "$COMMAND"
	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH" "binding" "$BINDING"

	local CURRENT_LIST
	CURRENT_LIST="$(gsettings get "org.gnome.settings-daemon.plugins.media-keys" custom-keybindings)"

	if [[ "$CURRENT_LIST" != *"$KEY_PATH"* ]]; then
		local NEW_LIST
		if [ "$CURRENT_LIST" = "@as []" ]; then
			NEW_LIST="['$KEY_PATH']"
		else
			NEW_LIST="${CURRENT_LIST%]}, '$KEY_PATH']"
		fi
		gsettings set "org.gnome.settings-daemon.plugins.media-keys" custom-keybindings "$NEW_LIST"
		echo "✅ $NAME added successfully."
	else
		echo "ℹ️  $NAME was already configured."
	fi
}

# Create Launchers
create_launcher 0   "Launch Settings"       "gnome-control-center"  "<Control><Alt>s"
create_launcher 1   "Launch Slack"          "slack"                 "<Control><Alt>m"
create_launcher 2   "Launch LibreOffice"    "soffice"               "<Control><Alt>l"
create_launcher 3   "Launch OnlyOffice"     "desktopeditors"        "<Control><Alt>o"
create_launcher 4   "Launch Ptyxis"         "ptyxis"                "<Control><Alt>y"
create_launcher 5   "Launch VS Code"        "code"                  "<Control><Alt>v"
create_launcher 6   "Launch Zed"            "zed"                   "<Control><Alt>z"
create_launcher 7   "Launch Kate"           "kate"                  "<Control><Alt>k"
create_launcher 8   "Launch Emacs"          "emacs"                 "<Control><Alt>e"
create_launcher 9   "Launch Wireshark"      "wireshark"             "<Control><Alt>w"
create_launcher 10  "Launch Insomnia"       "insomnia"              "<Control><Alt>i"
create_launcher 11  "Launch Postman"        "postman"               "<Control><Alt>p"
create_launcher 12  "Launch DBeaver"        "dbeaver-ce"            "<Control><Alt>d"


################################################################################################

### ################################
### Bash
### ################################


# Setup Bash
cat << 'EOF' | tee -a "${HOME}/.bashrc" | sudo tee -a "/root/.bashrc" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${PATH}:${HOME}/.cargo/bin"
export MICRO_TRUECOLOR=1

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

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

# QI Tech ALIAS
alias qi="qilocal"
alias qio="qilocal start"
alias qic="qilocal stop"
# Pre-Commit ALIAS
alias pc="pre-commit"
alias pcr="pre-commit run"
alias pca="pre-commit run --all"
# Software ALIAS
alias wh="which"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade --yes"
alias upsnap="sudo snap refresh"
alias upflat="flatpak update -y"
alias upbrew="brew update && brew upgrade"
alias upall="upapt && upsnap && upflat && upbrew"
# Emacs ALIAS
alias ek="pkill emacs"
alias es="emacs --daemon"
alias er="ek && es"
alias ec="emacsclient --create-frame --alternate-editor \"\""
alias oe="nohup emacsclient --create-frame --alternate-editor \"\" . &> \"/dev/null\" &"
# Code Editors ALIAS
alias ok="nohup kate . &> \"/dev/null\" &"
alias oc="nohup code . &> \"/dev/null\" &"
alias oz="nohup zed . &> \"/dev/null\" &"
alias on="nvim ."
alias ov="vim ."

### ################################
### SHELL FUNCTIONS
### ################################

function uutils() {
	export PATH="${HOME}/.local/bin/uutils:${PATH}"
}

### ################################
### SHELL CONFIGURATION
### ################################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gabrielfrigo/google-cloud-sdk/path.bash.inc' ]; then . '/home/gabrielfrigo/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gabrielfrigo/google-cloud-sdk/completion.bash.inc' ]; then . '/home/gabrielfrigo/google-cloud-sdk/completion.bash.inc'; fi

# Cargo Environment
if (( $(id -u) != 0 )); then
	[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
	uutils
fi
EOF


### ################################
### Zsh
### ################################


# Install Zsh
sudo apt install --yes zsh
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | bash -s -- --unattended
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | sudo bash -s -- --unattended
sudo chsh -s "$(which zsh)" "$(id -un)"
sudo chsh -s "$(which zsh)" "root"

# Setup Zsh
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

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${PATH}:${HOME}/.cargo/bin"
export MICRO_TRUECOLOR=1

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

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

# QI Tech ALIAS
alias qi="qilocal"
alias qio="qilocal start"
alias qic="qilocal stop"
# Pre-Commit ALIAS
alias pc="pre-commit"
alias pcr="pre-commit run"
alias pca="pre-commit run --all"
# Software ALIAS
alias wh="which"
alias mmdc="mmdc -p ~/.mermaid-puppeteer-config.json -c ~/.mermaid-theme-config.json -b \"#191919\" -s 4"
# Management ALIAS
alias upapt="sudo apt update && sudo apt upgrade --yes"
alias upsnap="sudo snap refresh"
alias upflat="flatpak update -y"
alias upbrew="brew update && brew upgrade"
alias upall="upapt && upsnap && upflat && upbrew"
# Emacs ALIAS
alias ek="pkill emacs"
alias es="emacs --daemon"
alias er="ek && es"
alias ec="emacsclient --create-frame --alternate-editor \"\""
alias oe="nohup emacsclient --create-frame --alternate-editor \"\" . &> \"/dev/null\" &"
# Code Editors ALIAS
alias ok="nohup kate . &> \"/dev/null\" &"
alias oc="nohup code . &> \"/dev/null\" &"
alias oz="nohup zed . &> \"/dev/null\" &"
alias on="nvim ."
alias ov="vim ."

### ################################
### SHELL FUNCTIONS
### ################################

function uutils() {
	export PATH="${HOME}/.local/bin/uutils:${PATH}"
}

### ################################
### SHELL CONFIGURATION
### ################################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gabrielfrigo/google-cloud-sdk/path.zsh.inc' ]; then . '/home/gabrielfrigo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gabrielfrigo/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/gabrielfrigo/google-cloud-sdk/completion.zsh.inc'; fi

# Cargo Environment
if (( $(id -u) != 0 )); then
	[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
	uutils
fi
EOF


################################################################################################

### ################################
### Installing System Fonts
### ################################


sudo apt install --yes fontconfig
mkdir -p "${HOME}/.local/share/fonts"


### ################################
### Nerd Fonts
### ################################


# https://www.nerdfonts.com/font-downloads
# Install RobotoMono
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip" -O "RobotoMono.zip"
unzip -o RobotoMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/LICENSE.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f RobotoMono.zip

# https://github.com/ryanoasis/nerd-fonts
# Install JetBrains
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O "JetBrainsMono.zip"
unzip -o JetBrainsMono.zip -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/OFL.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f JetBrainsMono.zip


### ################################
### JetBrains Mono
### ################################


# Install JetBrains Mono
sudo apt install --yes fonts-jetbrains-mono
bash -c "$(curl -fsSL "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh")"


### ################################
### MesloLGS
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
### Nerd Font Symbols Only
### ################################


# Setup Nerd Icons
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip" -O "NerdFontsSymbolsOnly.zip"
unzip -o "NerdFontsSymbolsOnly.zip" -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/10-nerd-font-symbols.conf"
rm -f "${HOME}/.local/share/fonts/LICENSE"
rm -f "${HOME}/.local/share/fonts/README.md"
rm "NerdFontsSymbolsOnly.zip"


### ################################
### Update Font
### ################################


# Update Font Cache
fc-cache -f


################################################################################################

### ################################
### VS Code
### ################################


# Automatically Setup VS Code
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

# Manually Setup VS Code
wget -qO- "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > "microsoft.gpg"
sudo install -D -o root -g root -m 644 "microsoft.gpg" "/usr/share/keyrings/microsoft.gpg"
rm -f "microsoft.gpg"

# Microsoft Package Repository
cat << 'EOF' | sudo tee "/etc/apt/sources.list.d/vscode.sources" > "/dev/null"
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Install VS Code
sudo apt update
sudo apt install --yes code



### ################################
### Zed
### ################################


# Install Zed
curl -f https://zed.dev/install.sh | bash

# Create Alias
sudo ln -sf "${HOME}/.local/bin/zed" "/usr/local/bin/zed"


### ################################
### Kate
### ################################


# Install Kate
flatpak install flathub -y org.kde.kate

# Create Alias
cat << 'EOF' | sudo tee "/usr/local/bin/kate" > "/dev/null"
#!/bin/bash
flatpak run org.kde.kate "$@"
EOF
sudo chmod +x "/usr/local/bin/kate"

# Create Desktop Icon
sudo find "/var/lib/flatpak" -name "org.kde.kate.svg" -exec cp {} "/usr/share/pixmaps/kate.svg" \; -quit
cat << 'EOF' | sudo tee "/usr/share/applications/org.kde.kate.desktop" > "/dev/null"
[Desktop Entry]
Name=Kate
GenericName=Editor de Texto
Comment=Editor de Texto Avançado do KDE (Custom Wrapper)
Exec=/usr/local/bin/kate %F
Icon=kate
Type=Application
Categories=Qt;KDE;Utility;TextEditor;
StartupNotify=true
StartupWMClass=kate
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-makefile;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;
EOF
sudo update-desktop-database

# Configure Profile
cat << 'EOF' | tee "${HOME}/.var/app/org.kde.kate/data/konsole/Profile NF.profile" > "/dev/null"
[Appearance]
Font=JetBrainsMonoNL Nerd Font Mono,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[General]
Command=/bin/zsh
Name=Profile NF
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

# Configure Terminal
cat << 'EOF' | tee "${HOME}/.var/app/org.kde.kate/config/konsolerc" > "/dev/null"
[Desktop Entry]
DefaultProfile=Profile NF.profile
EOF


### ################################
### Emacs
### ################################


# Install Emacs
sudo add-apt-repository --yes "ppa:ubuntuhandbook1/emacs"
sudo apt update
sudo apt install --yes emacs

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
### NeoVim
### ################################


# Install NeoVim
wget -qO "/tmp/nvim.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
sudo rm -rf "/opt/nvim"
sudo mkdir -p "/opt/nvim"
sudo tar -C "/opt/nvim" --strip-components=1 -xzf "/tmp/nvim.tar.gz"
for cmd in nvim vim vi; do
	sudo ln -sf "/opt/nvim/bin/nvim" "/usr/local/bin/$cmd"
done
rm "/tmp/nvim.tar.gz"

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
### Wireshark
### ################################


# Install Wireshark
sudo add-apt-repository --yes "ppa:wireshark-dev/stable"
sudo apt update
sudo apt install --yes wireshark

# Setup Wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -aG wireshark "$(id -un)"
newgrp wireshark

# Setup Theme
sudo apt install --yes adwaita-qt
sudo apt install --yes qt6-gtk-platformtheme
cp "/usr/share/applications/org.wireshark.Wireshark.desktop" "${HOME}/.local/share/applications/"
sed -i 's/^Exec=wireshark/Exec=env QT_STYLE_OVERRIDE=Adwaita-Dark /usr/bin/wireshark/g' "${HOME}/.local/share/applications/org.wireshark.Wireshark.desktop"

# Create Alias
cat << 'EOF' | sudo tee "/usr/local/bin/wireshark" > "/dev/null"
#!/bin/bash
QT_STYLE_OVERRIDE=Adwaita-Dark /usr/bin/wireshark "$@"
EOF
sudo chmod +x "/usr/local/bin/wireshark"


### ################################
### Insomnia
### ################################


# Install Insomnia (repositório)
curl -1sLf 'https://packages.konghq.com/public/insomnia/setup.deb.sh' | sudo -E bash
sudo apt update
sudo apt install --yes insomnia

# Install Insomnia (.deb)
wget -O insomnia.deb "https://updates.insomnia.rest/downloads/ubuntu/latest"
sudo apt install --yes ./insomnia.deb
rm ./insomnia.deb


### ################################
### Postman
### ################################


# Install Postman
sudo snap install postman


### ################################
### DBeaver
### ################################


# Install Postman
sudo snap install dbeaver-ce --classic


################################################################################################

### ################################
### GCloud
### ################################


# Setup GCloud
curl -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-428.0.0-linux-x86_64.tar.gz"
tar -zxf "google-cloud-cli-428.0.0-linux-x86_64.tar.gz"
rm "google-cloud-cli-428.0.0-linux-x86_64.tar.gz"
./google-cloud-sdk/install.sh
source "${HOME}/.bashrc"
gcloud auth login
gcloud auth configure-docker "us-central1-docker.pkg.dev"
gcloud components update


### ################################
### Docker
### ################################


# Remove Previous Docker
sudo apt remove --yes docker
sudo apt remove --yes docker-engine
sudo apt remove --yes docker.io
sudo apt remove --yes containerd
sudo apt remove --yes runc

# Install Requirements Docker
sudo apt install --yes ca-certificates
sudo apt install --yes curl
sudo apt install --yes gnupg
sudo apt install --yes lsb-release

# Add GPG Key Docker
curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | sudo gpg --dearmor -o "/usr/share/keyrings/docker-archive-keyring.gpg"
cat << EOF | sudo tee "/etc/apt/sources.list.d/docker.list" > "/dev/null"
deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF

# Install Docker
sudo apt update
sudo apt install --yes docker-ce docker-ce-cli containerd.io

# Setup Group
sudo groupadd docker
sudo usermod -aG docker "$(id -un)"
newgrp docker


### ################################
### MySQL
### ################################


# Install MySQL Client
sudo apt install --yes mysql-client

# Install MySQL Common
sudo apt install --yes mysql-common

# Install MySQL Server
sudo apt install --yes mysql-server

# Stop MySQL Server
sudo systemctl stop mysql.service

# Disable MySQL Server
sudo systemctl disable mysql.service


################################################################################################


### ################################
### QI Local
### ################################


# Install QI Local
python3.10 -m pip install "git+ssh://git@gitclone.qitech.com.br/QITech/qi-infra/corp/qilocal.git"
python3.11 -m pip install "git+ssh://git@gitclone.qitech.com.br/QITech/qi-infra/corp/qilocal.git"


### ################################
### GitLab
### ################################


# Clone QI Local
git qiclone \
	"git@gitclone.qitech.com.br:QITech/qi-infra/corp/qilocal.git" \
	"${HOME}/Documents/1) Git/Mirrors/qilocal"

# Clone Base API
git qiclone \
	"git@gitclone.qitech.com.br:QITech/base-api.git" \
	"${HOME}/Documents/1) Git/Mirrors/base-api"

# Clone Automatic Pix API
git qiclone \
	"git@gitclone.qitech.com.br:qibaas/automatic-pix-api.git" \
	"${HOME}/Documents/1) Git/Mirrors/automatic-pix-api"

# Clone Pix Transfer API
git qiclone \
	"git@gitclone.qitech.com.br:qibaas/pix-transfer-api.git" \
	"${HOME}/Documents/1) Git/Mirrors/pix-transfer-api"

# Clone Smart Pix API
git qiclone \
	"git@gitclone.qitech.com.br:qibaas/smart-pix-api.git" \
	"${HOME}/Documents/1) Git/GitLab/smart-pix-api"


### ################################
### GitHub
### ################################


# Clone Unix Socket Project
git clone \
	"https://github.com/GabrielFrigo4/unix-sock" \
	"${HOME}/Documents/1) Git/GitHub/unix-sock"

# Clone Frigo's Standard Library in C 
git clone \
	"https://github.com/GabrielFrigo4/stdfrigo" \
	"${HOME}/Documents/1) Git/GitHub/stdfrigo"


################################################################################################

### ################################
### Template
### ################################
