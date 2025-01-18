#!/usr/bin/env bash

xcode-select --install
rm -f ~/Makefile
curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/Makefile > ~/Makefile
