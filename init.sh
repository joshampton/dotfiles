#!/usr/bin/env bash

rm -f ~/Makefile
curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/Makefile > ~/Makefile
make -C ~ init
