#!/usr/bin/env bash

xcode-select --install
sudo softwareupdate --install-rosetta
rm -f ~/Makefile
curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/Makefile > ~/Makefile
