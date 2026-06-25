#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup MSYS2
### ################################

cat << 'EOF' | tee -a "/clang64.ini" | tee -a "/clangarm64.ini" | tee -a "/mingw32.ini" | tee -a "/mingw64.ini" | tee -a "/msys2.ini" | tee -a "/ucrt64.ini" > "/dev/null"
SHELL=/usr/bin/bash
EOF

### ################################
### Setup Server
### ################################

cat << 'EOF' | tee "/usr/local/bin/frigo-server" > "/dev/null"
#!/usr/bin/zsh
source "${HOME}/.vault/servers/servers.env"
ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
EOF
chmod +x "/usr/local/bin/frigo-server"

cat << 'EOF' | tee "/usr/local/bin/orbs-server" > "/dev/null"
#!/usr/bin/zsh
source "${HOME}/.vault/servers/servers.env"
ssh -i "${ORBS_SERVER_KEY}" "ubuntu@${ORBS_SERVER_IP}"
EOF
chmod +x "/usr/local/bin/orbs-server"

### ################################################################################################################################

### ################################
### Installing Base Tools
### ################################

pacman --needed --noconfirm -S base-devel
pacman --needed --noconfirm -S binutils
pacman --needed --noconfirm -S coreutils
pacman --needed --noconfirm -S sys-utils

### ################################
### Installing Croos Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-cross-toolchain
pacman --needed --noconfirm -S mingw-w64-cross

### ################################
### Installing Default Tools
### ################################

pacman --needed --noconfirm -S git
pacman --needed --noconfirm -S make
pacman --needed --noconfirm -S cmake

### ################################
### Installing Default Editors
### ################################

pacman --needed --noconfirm -S editors

### ################################
### Installing Default Net
### ################################

pacman --needed --noconfirm -S openssh
pacman --needed --noconfirm -S net-utils
pacman --needed --noconfirm -S lynx

### ################################
### Installing Default Manual
### ################################

pacman --needed --noconfirm -S man-db
pacman --needed --noconfirm -S man-pages-posix

### ################################################################################################################################

### ################################
### Setup Bash
### ################################

pacman --needed --noconfirm -S bash

### ################################
### Installing Zsh Shell
### ################################

pacman --needed --noconfirm -S zsh

### ################################################################################################################################

### ################################
### Installing UCRT64 Coreutils
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-uutils-coreutils

### ################################
### Installing UCRT64 Toolchain
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-toolchain
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-binutils
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ntldd

### ################################
### Installing UCRT64 Build System
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cmake
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ninja
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-meson

### ################################
### Installing UCRT64 Clang System
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-clang
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-clang-analyzer
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-clang-tools-extra
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-clang-libs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-lldb

### ################################################################################################################################

### ################################
### Installing Git Dev Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-git
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-git-archimport
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-git-credential-wincred
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-github-cli

### ################################
### Installing Avr Dev Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-avr-toolchain
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-avr-binutils
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-avrdude

### ################################
### Installing System Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-dbus

### ################################################################################################################################

### ################################
### Installing Assembly Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-nasm
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-asm-lsp

### ################################
### Installing Rust Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-rustup
rustup update
rustup default stable
rustup toolchain install stable

rustup toolchain install stable-x86_64-pc-windows-gnullvm
rustup default stable-x86_64-pc-windows-gnullvm

rustup toolchain install stable-x86_64-pc-windows-msvc
rustup default stable-x86_64-pc-windows-msvc

rustup toolchain install stable-x86_64-pc-windows-gnu
rustup default stable-x86_64-pc-windows-gnu

cargo install cargo-update
cargo install-update -a

### ################################
### Installing Go Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-go

### ################################
### Installing Scala Language
### ################################

wget -qO cs.zip "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-win32.zip"
unzip -q cs.zip -d "/usr/local/bin"
mv "/usr/local/bin/cs-x86_64-pc-win32.exe" "/usr/local/bin/cs.exe"
rm cs.zip

cs setup
cs install scalafmt

### ################################
### Installing Lua Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-lua
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-luajit
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-lua-luarocks

### ################################
### Installing Python Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cython
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-mypy

cargo install --git https://github.com/RustPython/RustPython rustpython

### ################################
### Installing Lisp Language
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sbcl

### ################################################################################################################################

### ################################
### Installing C/C++ Packages
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-capstone
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-unicorn

### ################################################################################################################################

### ################################
### Installing Lua Modules
### ################################

luarocks install lua-cjson
luarocks install luafilesystem
luarocks install luasocket
luarocks install cffi-lua
luarocks install lpeg

### ################################
### Installing Lua Standard
### ################################

luarocks install penlight

### ################################################################################################################################

### ################################
### Installing Python Modules
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pip
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pipx
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-uv

### ################################
### Installing Python Packages
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-capstone
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-unicorn
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-cryptography
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pynacl
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-cffi
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pywin32
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-psutil
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-zstandard

### ################################
### Installing Python Libraries
### ################################

python -m pip install --break-system-packages six
python -m pip install --break-system-packages python-dateutil
python -m pip install --break-system-packages sortedcontainers
python -m pip install --break-system-packages intervaltree
python -m pip install --break-system-packages PySocks
python -m pip install --break-system-packages requests
python -m pip install --break-system-packages pyserial
python -m pip install --break-system-packages paramiko
python -m pip install --break-system-packages pyelftools
python -m pip install --break-system-packages unix-ar
python -m pip install --break-system-packages mako
python -m pip install --break-system-packages colored-traceback
python -m pip install --break-system-packages --no-deps plumbum
python -m pip install --break-system-packages rpyc

### ################################
### Installing Python Programs
### ################################

python -m pip install --break-system-packages --no-deps ropgadget
python -m pip install --break-system-packages --no-deps pwntools

### ################################
### Installing Python Converter
### ################################

python -m pip install --break-system-packages weasyprint

### ################################################################################################################################

### ################################
### Installing C/C++/Rust Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-fd
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-dust
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-grep
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-bat
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-eza
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ripgrep
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-repgrep

### ################################
### Installing LaTeX Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-bin
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-core
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-extra-utils
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-latex-extra
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-lang-portuguese
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-fonts-extra
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-texlive-fonts-recommended

### ################################
### Installing PDF Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-emacs-pdf-tools-server

### ################################
### Installing Convert Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-imagemagick
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ffmpeg

### ################################
### Installing OCR Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tesseract-ocr

### ################################
### Installing Zed Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ollama
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-rust-analyzer

### ################################
### Installing Hardware Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-eda

### ################################
### Installing Fetch Tools
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-fastfetch

### ################################
### Installing Software
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-emacs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-neovim
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-zed
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-helix

### ################################################################################################################################

### ################################
### Installing Micro
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-micro

### ################################
### Installing Theme in Micro
### ################################

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
### LibC Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-gcc-libs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-compiler-rt
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libunwind
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libc++abi
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libc++

### ################################
### Threads Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-llvm-openmp
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libwinpthread
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-winpthreads
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libuv
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tbb

### ################################
### ZLib Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-minizip-ng
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-minizip
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-zlib
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-zstd

### ################################
### SSL Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libressl
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-openssl
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libsodium

### ################################
### LibUSB Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libserialport
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libusb-win32
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libusb
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-hidapi

### ################################
### ZMQ Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-zeromq
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cppzmq

### ################################
### FreeRDP Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-freerdp

### ################################
### LibArchive Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libarchive

### ################################
### LibSndFile Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libsndfile

### ################################
### TagLib Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-taglib

### ################################
### Tree-Sitter Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libtree-sitter
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-c
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-lua
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-vim
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-query
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-vimdoc
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-tree-sitter-markdown

wget -O libtree-sitter.pkg "https://repo.msys2.org/mingw/ucrt64/mingw-w64-ucrt-x86_64-libtree-sitter-0.25.9-1-any.pkg.tar.zst"
pacman -U --noconfirm "libtree-sitter.pkg"
rm "libtree-sitter.pkg"

# REVERTER: Remove o pacote da lista de ignorados (Permite atualizar novamente)
sed -i 's/ mingw-w64-ucrt-x86_64-libtree-sitter//' "/etc/pacman.conf"
sed -i 's/^IgnorePkg/#IgnorePkg/' "/etc/pacman.conf"

# BLOQUEAR: Adiciona o pacote na lista de ignorados (Impede atualização/Trava versão)
sed -i 's/^#IgnorePkg/IgnorePkg/' "/etc/pacman.conf"
sed -i '/^IgnorePkg/ s/$/ mingw-w64-ucrt-x86_64-libtree-sitter/' "/etc/pacman.conf"

### ################################
### SQL Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sqlite-docs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sqlite3
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-postgresql

### ################################
### Terminal Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-pdcurses
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-notcurses
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-ncurses
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-readline

### ################################
### Internet Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-curl

### ################################
### FreeType Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-freetype

### ################################
### STB Like Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-stb
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-miniaudio
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-doctest

### ################################
### Header Only Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-uthash
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-nlohmann-json

### ################################
### Text Rendering Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-pango
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cairo

### ################################
### Text Formatting Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-fmt

### ################################
### DirectX Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-directx-headers
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-directxmath
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-directxmesh
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-directxtex
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-directxtk

### ################################
### Vulkan Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-vulkan-devel

### ################################
### OpenGL Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opengl-man-pages
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glm
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cglm
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glew

# MESA is an Open-Source Driver
#pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-mesa

### ################################
### OpenCL Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-headers
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-clhpp
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-icd
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libclc

### ################################
### OpenAL Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-openal

### ################################
### RayLib Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-raylib

### ################################
### SFML Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sfml-docs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sfml
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-csfml-docs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-csfml

### ################################
### GLFW Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glfw-docs
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glfw

### ################################
### SDL 3.0 Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3-image
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3-ttf

### ################################
### SDL 2.0 Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_gfx
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_image
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_mixer
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_net
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_pango
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_sound
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-SDL2_ttf

### ################################
### GTK+ Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glib2

### ################################
### GTK 4.0 Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-gtk4

### ################################
### GTK 3.0 Dependencies
### ################################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-gtk3

### ################################
### QT 6.0 Dependencies
### ###############################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-qt6

### ################################
### QT 5.0 Dependencies
### ###############################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-qt5

### ################################
### EAF Dependencies
### ###############################

pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pyqt6
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pyqt6-sip
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-pymupdf
pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-python-lxml

### ################################################################################################################################
