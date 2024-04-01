# dotfiles

Cross-platform dotfiles. Works on Linux, macOS, Windows, and WSL.

## Prerequisites

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- bash (comes with Linux / macOS / WSL, or with git for Windows)

## Install

```sh
git clone https://github.com/syhner/dotfiles.git
cd dotfiles
./install.sh
```

This will:

1. Copy files from [`home/`](home/) to your home directory. Replaced files are kept at `backups/` in your local dotfiles repo, which is gitignored.
2. Run package install scripts in [`packages-install/`](packages-install/) using the right package manager (apt for Linux / WSL, Homebrew for macOS, winget for Windows).
