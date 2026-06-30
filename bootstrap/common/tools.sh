#!/bin/sh

### ################################################################################################################################

### ################################
### Deploy Tool Configs
### ################################

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_REPO="$(cd "${SCRIPT_DIR}/../.." && pwd)"

### ################################
### Clangd Config
### ################################

mkdir -p "${HOME}/.config/clangd"
cp "${CONFIG_REPO}/software/tools/clangd.yaml" "${HOME}/.config/clangd/config.yaml"

### ################################
### Clang Format
### ################################

cp "${CONFIG_REPO}/software/tools/.clang-format" "${HOME}/.clang-format"

### ################################
### Prettier Config
### ################################

cp "${CONFIG_REPO}/software/tools/.prettierrc" "${HOME}/.prettierrc"

### ################################
### StyLua Config
### ################################

cp "${CONFIG_REPO}/software/tools/.stylua.toml" "${HOME}/.stylua.toml"

### ################################################################################################################################
