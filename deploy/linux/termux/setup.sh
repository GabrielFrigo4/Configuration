#!/usr/bin/sh

### ################################################################################################################################

### ################################
### Setup Environment
### ################################

# System
pkg install -y build-essential
pkg install -y coreutils
pkg install -y binutils

# Files
apt install -y unzip zip gzip p7zip tar
pkg install -y make cmake
pkg install -y curl wget

# Git & GitHuib
pkg install -y git gh

### ################################################################################################################################

### ################################
### Updating Pkg
### ################################

pkg update
pkg upgrade -y

### ################################
### Install Shell Tools
### ################################

# Man
pkg install -y man
pkg install -y manpages
pkg install -y qman
# Net
pkg install -y nmap
pkg install -y net-tools
apt install -y openssh
# Fetch
pkg install -y fastfetch
# Security
apt install -y openssl-tool
# Editor
apt install -y sed ed

### ################################################################################################################################

### ################################
### Installing Languages
### ################################

pkg install -y clang llvm lld lldb gdb
pkg install -y python python-pip
pkg install -y lua luarocks

### ################################################################################################################################

### ################################
### Installing Editors
### ################################

pkg install -y emacs
pkg install -y helix
pkg install -y vim
pkg install -y neovim
pkg install -y micro
pkg install -y nano

### ################################################################################################################################
