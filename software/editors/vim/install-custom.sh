#!/usr/bin/env sh

### ================================
### Installing Vim Custom
### ================================

git clone "https://github.com/GabrielFrigo4/vimfiles" "${HOME}/.vim"

### ================================
### Configuring Vim Entry Point
### ================================

cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/.vim
source ~/.vim/vimrc
EOF
