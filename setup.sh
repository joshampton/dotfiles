#!/usr/bin/env bash

rm -f ~/Makefile
curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/Makefile > ~/Makefile
make -C ~ install-homebrew
# make -C ~ install-packages
# make -C ~ install-oh-my-zsh
# make -C ~ install-asdf
# make -C ~ system-setup
