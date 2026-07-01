#!/usr/bin/sh

### ################################
### Installing Python
### ################################

yay --needed --noconfirm -S python
yay --needed --noconfirm -S pypy3
yay --needed --noconfirm -S pypy
yay --needed --noconfirm -S mypy
cargo install --git https://github.com/RustPython/RustPython rustpython

### ################################
### Installing Python Packages
### ################################

yay --needed --noconfirm -S python-venv
yay --needed --noconfirm -S python-pip
yay --needed --noconfirm -S python-pipx
yay --needed --noconfirm -S uv

yay --needed --noconfirm -S cython

### ################################
### Installing Python Libraries
### ################################

yay --needed --noconfirm -S python-pytooling
yay --needed --noconfirm -S python-pyautogui
yay --needed --noconfirm -S python-pillow
yay --needed --noconfirm -S python-pwntools
yay --needed --noconfirm -S python-google-genai
yay --needed --noconfirm -S python-weasyprint
yay --needed --noconfirm -S python-matplotlib
yay --needed --noconfirm -S python-cairo
yay --needed --noconfirm -S python-pulp
yay --needed --noconfirm -S python-networkx
yay --needed --noconfirm -S python-igraph
yay --needed --noconfirm -S python-websockets
yay --needed --noconfirm -S python-pystun3
yay --needed --noconfirm -S python-flask
