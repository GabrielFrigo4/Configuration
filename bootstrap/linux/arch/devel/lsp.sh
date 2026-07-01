#!/usr/bin/sh

### ################################
### Installing LSP Servers
### ################################

go install golang.org/x/tools/gopls@latest
yay --needed --noconfirm -S prettier
yay --needed --noconfirm -S stylua

yay --needed --noconfirm -S asm-lsp
