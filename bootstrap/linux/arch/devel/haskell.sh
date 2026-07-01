#!/usr/bin/sh

### ################################
### Installing Haskell
### ################################

yay --needed --noconfirm -S cabal-install
yay --needed --noconfirm -S stack
yay --needed --noconfirm -S ghc

### ################################
### Installing Haskell Libraries
### ################################

yay --needed --noconfirm -S ghc-static
yay --needed --noconfirm -S ghc-libs
