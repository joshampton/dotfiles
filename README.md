# TODO

- [ ] investigate ansible

# Installation Checklist

- [ ] Copy private files
- [ ] Init
- [ ] Setup
- [ ] Link
- [ ] OS

## Init

Install system dependencies:

```console
bash <(curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/init.sh)
```

## Setup

Installs brew, applications, oh-my-zsh, and asdf:

```console
make -C ~ setup
```

## Link

```console
make -C ~ link
```

## OS

Modifies OS preferences and reindexes spotlight:

```console
make -C ~ os
```
