#!/usr/bin/sh

### ################################
### Installing Python
### ################################

sudo apt install --yes python3
sudo apt install --yes pypy3
sudo apt install --yes mypy
cargo install --git https://github.com/RustPython/RustPython rustpython
