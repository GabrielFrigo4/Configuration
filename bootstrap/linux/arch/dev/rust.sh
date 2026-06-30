#!/usr/bin/sh

### ################################
### Installing Rust
### ################################

yay --needed --noconfirm -S rustup
rustup update
rustup default stable
rustup toolchain install stable

yay --needed --noconfirm -S gcc-rust
