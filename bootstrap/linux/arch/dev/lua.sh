#!/usr/bin/sh

### ################################
### Installing Lua
### ################################

yay --needed --noconfirm -S lua
yay --needed --noconfirm -S luajit
yay --needed --noconfirm -S nelua-git

### ################################
### Installing Lua Packages
### ################################

yay --needed --noconfirm -S luarocks

# https://luarocks.org/
sudo luarocks install lua-cjson
sudo luarocks install luafilesystem
sudo luarocks install luasocket
sudo luarocks install cffi-lua
sudo luarocks install lpeg

sudo luarocks install penlight
