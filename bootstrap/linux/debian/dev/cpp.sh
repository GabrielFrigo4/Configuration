#!/usr/bin/sh

### ################################
### Installing C/C++ Languages
### ################################

sudo apt install --yes clang clang-tools clangd lldb
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"

### ################################
### Installing System Libraries
### ################################

sudo apt install --yes libxml++2.6-dev
sudo apt install --yes libvterm-dev
sudo apt install --yes libtree-sitter-dev
sudo apt install --yes libminizip-dev
sudo apt install --yes zlib1g-dev
sudo apt install --yes openssl
sudo apt install --yes libssl-dev
sudo apt install --yes libsodium-dev
sudo apt install --yes libfyaml-dev
sudo apt install --yes libfyaml-utils
sudo apt install --yes libfyaml0

### ################################
### Installing C Libraries
### ################################

sudo apt install --yes libusb-dev
sudo apt install --yes libglfw3-dev
sudo apt install --yes libglfw3-doc
sudo apt install --yes libsdl3-dev
sudo apt install --yes libsdl3-doc
sudo apt install --yes libsdl3-image-dev
sudo apt install --yes libsdl3-image-doc
sudo apt install --yes libsdl3-ttf-dev
sudo apt install --yes libsdl3-ttf-doc
sudo apt install --yes libsfml-dev
sudo apt install --yes libsfml-doc
sudo apt install --yes libcsfml-dev
sudo apt install --yes libcsfml-doc
sudo apt install --yes libglm-dev
sudo apt install --yes libglm-doc
sudo apt install --yes libcglm-dev
sudo apt install --yes libcglm-doc
sudo apt install --yes libglew-dev
sudo apt install --yes opengl-4-man-doc
sudo apt install --yes libopenal-dev
sudo apt install --yes opencl-headers
sudo apt install --yes ocl-icd-opencl-dev
sudo apt install --yes libclc-19
sudo apt install --yes opencl-1.2-man-doc
sudo apt install --yes libfreetype-dev
