#!/usr/bin/env sh
set -e

### ================================
### Installing SpaceVim Framework
### ================================

### --------------------------------
### Remove Lixo
### --------------------------------
rm -rf "${HOME}/.vim" 2> "/dev/null"
rm -rf "${HOME}/.vimrc" 2> "/dev/null"
rm -rf "${HOME}/.SpaceVim" 2> "/dev/null"
rm -rf "${HOME}/.SpaceVim.d" 2> "/dev/null"

### --------------------------------
### Setup SpaceVim
### --------------------------------
git clone "https://github.com/SpaceVim/SpaceVim.git" "${HOME}/.SpaceVim"
mkdir -p "${HOME}/.SpaceVim.d/autoload"

### --------------------------------
### Setup Nerd Icons
### --------------------------------
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip" -O "NerdFontsSymbolsOnly.zip"
unzip -o "NerdFontsSymbolsOnly.zip" -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/10-nerd-font-symbols.conf"
rm -f "${HOME}/.local/share/fonts/LICENSE"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f "NerdFontsSymbolsOnly.zip"

### --------------------------------
### Install JetBrains Mono
### --------------------------------
bash -c "$(curl -fsSL "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh")"
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O "JetBrainsMono.zip"
unzip -o "JetBrainsMono.zip" -d "${HOME}/.local/share/fonts"
rm -f "${HOME}/.local/share/fonts/OFL.txt"
rm -f "${HOME}/.local/share/fonts/README.md"
rm -f "JetBrainsMono.zip"
fc-cache -f

### --------------------------------
### Setup init.toml
### --------------------------------
cat << 'EOF' | tee "${HOME}/.SpaceVim.d/init.toml" > "/dev/null"
# =============================================================================
# Opções Gerais
# =============================================================================
[options]
   # Define a fonte (Importante para GUIs, mas ajuda na detecção de ícones)
   guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
   
   # Tema
   colorscheme = "onedark"
   colorscheme_bg = "dark"
   
   # Statusline e Ícones
   enable_statusline_mode = true
   statusline_separator = "arrow"
   enable_tabline_filetype_icon = true
   enable_bufferline = true
   
   # Aponta para a função de bootstrap (onde configuramos o cursor)
   bootstrap_before = "myspacevim#before"

# =============================================================================
# Layers (Plugins)
# =============================================================================
[[layers]]
   name = "autocomplete"
   auto_completion_return_key_behavior = "complete"
   auto_completion_tab_key_behavior = "smart"

[[layers]]
   name = "shell"
   default_position = "bottom"
   default_height = 30

[[layers]]
   name = "git"

[[layers]]
   name = "lsp"
EOF

### --------------------------------
### Setup myspacevim.vim
### --------------------------------
cat << 'EOF' | tee "${HOME}/.SpaceVim.d/autoload/myspacevim.vim" > "/dev/null"
function! myspacevim#before() abort
   " Ativar Cursor Piscante
   let &t_SI = "\e[5 q"
   let &t_SR = "\e[3 q"
   let &t_EI = "\e[1 q"
   
   " Configura o comportamento do cursor para Block/Line
   set guicursor+=n-v-c:blinkon1
   set guicursor+=i-ci:ver25-blinkon1
endfunction
EOF
