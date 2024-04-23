# dotfiles

Cross-platform dotfiles. Works on Linux, macOS, Windows, and WSL.

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

1. Copy files from [`home/`](home/) to your home directory. Replaced files are saved to `backups/` (and gitignored) in your local dotfiles repo.

   - both bash and zsh will source `$HOME/source/*.sh` files in order
   - bash will source `$HOME/source/*.bash` files in order
   - zsh will source `$HOME/source/*.zsh` files in order

2. Check for / update package manager (apt for Linux / WSL, Homebrew for macOS, winget for Windows).
3. Run package install scripts in [`scripts/install/`](scripts/install/) using the right package manager

## Guide

[Scripts](scripts/) can also be called individually, e.g.

```sh
# Push dotfiles to your home directory
./scripts/set-home-files.sh push $HOME

# Pull dotfiles from your home directory
./scripts/set-home-files.sh pull $HOME

# Pull dotfiles from a backup
./scripts/set-home-files.sh pull backups/2000-01-01T00:00:00Z

# Install a package (e.g. fzf)
./scripts/install/fzf.sh
```

## TODO

- tmux / zellij
- editors
  - neovim
- cli tools
  - and more from previous Brewfile
- mac
  - karabiner
  - yabai
  - skhd
- functions
  - kill process on port with signal
- UX
  - nicer logs
  - interactive installer (choose packages)
  - uninstaller
- robustness
  - clean up deleted `source-<number>/` files
  - CI
    - shellcheck
    - build on different platforms
- encrypted secrets
- anything personal to be injected through toml file inputs
