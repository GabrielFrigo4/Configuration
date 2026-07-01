#!/usr/bin/sh

### ################################
### Installing Rust
### ################################

sudo apt install --yes rust-all
rustup update
rustup default stable
rustup toolchain install stable
