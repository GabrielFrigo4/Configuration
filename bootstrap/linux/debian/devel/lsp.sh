#!/usr/bin/sh

### ################################
### Installing LSP Servers
### ################################

go install golang.org/x/tools/gopls@latest
cargo install stylua

cargo install asm-lsp

sudo apt install --yes clangd
