#!/usr/bin/sh

### ################################
### Installing C/C++ Languages
### ################################

yay --needed --noconfirm -S gcc
yay --needed --noconfirm -S clang llvm lld lldb
yay --needed --noconfirm -S musl
yay --needed --noconfirm -S bear
sudo ln -f "/usr/bin/gcc" "/usr/bin/cc"
sudo ln -f "/usr/bin/g++" "/usr/bin/CC"
sudo ln -f "/usr/bin/g++" "/usr/bin/c++"

yay --needed --noconfirm -S adaptivecpp

### ################################
### Installing C Libraries
### ################################

yay --needed --noconfirm -S klib
yay --needed --noconfirm -S glibc
yay --needed --noconfirm -S libfyaml
yay --needed --noconfirm -S libarchive
yay --needed --noconfirm -S libsndfile
yay --needed --noconfirm -S libserialport
yay --needed --noconfirm -S libusb
yay --needed --noconfirm -S hidapi
yay --needed --noconfirm -S zeromq
yay --needed --noconfirm -S cppzmq
yay --needed --noconfirm -S glfw
yay --needed --noconfirm -S sdl3
yay --needed --noconfirm -S sdl3_image
yay --needed --noconfirm -S sdl3_sound
yay --needed --noconfirm -S sdl3_mixer
yay --needed --noconfirm -S sdl3_ttf
yay --needed --noconfirm -S sdl3_shadercross
yay --needed --noconfirm -S sfml
yay --needed --noconfirm -S csfml
yay --needed --noconfirm -S glm
yay --needed --noconfirm -S cglm
yay --needed --noconfirm -S glew
yay --needed --noconfirm -S opengl-man-pages
yay --needed --noconfirm -S openal
yay --needed --noconfirm -S opencl-icd-loader
yay --needed --noconfirm -S libclc
yay --needed --noconfirm -S freetype2
yay --needed --noconfirm -S cairo
yay --needed --noconfirm -S igraph
