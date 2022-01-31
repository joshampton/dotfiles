# Checklist

- [ ] Copy private files
- [ ] Init
- [ ] Setup
- [ ] Link
- [ ] OS

## Init

Install system dependencies and initializes the home directory as a git repo:

```console
bash <(curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/init.sh)
```

## Setup

Installs brew, applications, oh-my-zsh, and asdf:

```console
make -C ~ setup
```

## OS

Modifies OS preferences and reindexes spotlight:

```console
make -C ~ os
```
