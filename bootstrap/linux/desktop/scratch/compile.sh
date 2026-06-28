#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Compile Vim
### ################################

cd "/tmp"
git clone "https://github.com/vim/vim.git"
cd vim
./configure
make -j$(nproc)
sudo make install
cd ~
sudo rm -r "/tmp/vim"

### ################################################################################################################################

### ################################
### Compile Emacs
### ################################

cd "/tmp"
git clone "https://git.savannah.gnu.org/git/emacs.git"
cd emacs
./autogen.sh
./configure
make -j$(nproc)
sudo make install
cd ~
sudo rm -r "/tmp/emacs"

### ################################################################################################################################

### ################################
### Compile SDL3 (Wayland)
### ################################

cd /tmp
git clone "https://github.com/libsdl-org/SDL.git"
cd SDL
mkdir build
cd build
cmake -DSDL_WAYLAND=ON ..
make -j$(nproc)
sudo make install
sudo ldconfig
cd ~
rm -rf "/tmp/SDL"

### ################################
### Compile SDL3 (ManPages)
### ################################

cd /tmp
git clone "https://github.com/libsdl-org/SDL.git"
cd SDL
mkdir build
cd build
cmake -DSDL_INSTALL_DOCS=ON ..
make -j$(nproc) SDL3-docs
sudo mkdir -p "/usr/local/share/man/man3"
sudo cp docs/man/man3/*.3 "/usr/local/share/man/man3/"
sudo mandb
cd ~
rm -rf "/tmp/SDL"

### ################################################################################################################################

### ################################
### Compile TT Core Collection
### ################################

cd "/tmp"
git clone "https://github.com/GabrielFrigo4/TTCC.git"
cd TTCC
make -j$(nproc)
sudo make install
cd ~
sudo rm -rf "/tmp/TTCC"

### ################################################################################################################################
