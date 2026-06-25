#!/usr/bin/env bash

# Load variables from Vault
source "${HOME}/.vault/config.env"

rm -f "${HOME}/.gitconfig"
git config --global credential.helper "!gh auth git-credential"
git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

gh auth login
gh auth setup-git
