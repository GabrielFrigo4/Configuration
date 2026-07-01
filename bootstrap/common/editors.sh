#!/bin/sh

### ################################################################################################################################

### ################################
### Setup Emacs Config
### ################################

mkdir -p "${HOME}/.emacs.d"
git clone "https://github.com/GabrielFrigo4/.emacs.d.git" "${HOME}/.emacs.d"
git -C "${HOME}/.emacs.d" pull

### ################################
### Setup NeoVim Config
### ################################

mkdir -p "${HOME}/.config/nvim"
git clone "https://github.com/GabrielFrigo4/nvim.git" "${HOME}/.config/nvim"
git -C "${HOME}/.config/nvim" pull

### ################################
### Setup Vim Config
### ################################

git clone "https://github.com/GabrielFrigo4/vimfiles.git" "${HOME}/vimfiles"
cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/vimfiles
source ~/vimfiles/vimrc
EOF
git -C "${HOME}/vimfiles" pull

### ################################
### Setup Helix Config
### ################################

git clone "https://github.com/GabrielFrigo4/helix.git" "${HOME}/.config/helix"
git -C "${HOME}/.config/helix" pull

### ################################
### Setup Micro Config
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
