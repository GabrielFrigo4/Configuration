#!/bin/sh

### ################################################################################################################################

### ################################
### Microsoft System Fonts
### ################################

sudo pkg install --yes fontconfig
sudo pkg install --yes webfonts
sudo pkg install --yes crosextrafonts-caladea
sudo pkg install --yes crosextrafonts-carlito

### ################################
### Nerd Fonts
### ################################

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/../../common/fonts.sh"

### ################################################################################################################################
