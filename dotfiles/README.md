# dotfiles

Cross-platform dotfiles. Works on Linux, macOS, Windows, and WSL.

## Overview

- Terminal emulator - Alacritty
- Terminal multiplexer - Zellij
- Shell - zsh
- Editor - Neovim / VS Code
- Font - CaskaydiaCove Nerd Font Mono
- Theme - Tokyo Night

## Prerequisites

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- bash (comes with Linux / macOS / WSL, or with git for Windows)

### Windows

Installed packages may not be found / not add to your PATH automatically (i.e. due to not having admin privileges / not in developer mode). In this case, you will need to do the following (requires admin privileges):

- Settings > System Properties > Environment Variables > (User or System) Variables > Path > New > `%USERPROFILE%\AppData\Local\Microsoft\WinGet\Links`

## Install

```sh
git clone --depth 1 https://github.com/syhner/dotfiles.git
cd dotfiles
./install.sh
```

This will:

1. Copy files from [`home/`](home/) to your home directory

   - both bash and zsh will source `$HOME/source/*.sh` files in order
   - bash will source `$HOME/source/*.bash` files in order
   - zsh will source `$HOME/source/*.zsh` files in order

2. Check for / update package manager (apt for Linux / WSL, Homebrew for macOS, winget for Windows).
3. Run package install scripts in [`scripts/install/`](scripts/install/) using the right package manager

## Guide

[Scripts](scripts/) can also be called individually, e.g.

```sh
# Set home files
./scripts/set-home-files.sh

# Set home files for a particular package
./scripts/set-home-files.sh nvim

# Install a package (e.g. fzf)
./scripts/install/fzf.sh
```

### Encrypting files

```sh
gpg --encrypt-files --recipient "<your id/email>" <files>
```

### Decrypting files

```sh
gpg --decrypt-files --yes <files>
```

## TODO

- ls tab colors matching eza
- handle folder sync between platforms (e.g. neovim)
- functions
  - kill process on port with signal
- robustness
  - overwrite source directory when pushing
  - CI
    - shellcheck
    - build on different platforms
- add
  - email
  - IRC
  - RSS reader
  - monitor
  - audio?
  - file manager?
- set $DOTFILES in a single place
- use get_os() instead of $OSTYPE
- fix zellij copy_command on non-mac (since it runs system executables as commands, not wrapped by system shell)
- replace alacritty with ghostty
- composable dotfiles
