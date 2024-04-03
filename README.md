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
git clone https://github.com/syhner/dotfiles.git
cd dotfiles
./install.sh
```

This will:

1. Copy files from [`home/`](home/) to your home directory. Replaced files are kept at `backups/` in your local dotfiles repo, which is gitignored.

   - bash and zsh will source `home/source-<number>/*.sh` files in order
   - bash will source `home/source-<number>/*.bash` files in order
   - zsh will source `home/source-<number>/*.zsh` files in order

2. Check for package manager (apt for Linux / WSL, Homebrew for macOS, winget for Windows).
3. Run package install scripts in [`scripts/install/`](scripts/install/) using the right package manager

## TODO

- git
  - config
  - aliases in bash
- fonts
- tmux
- editors
  - neovim
  - vscode
- cli tools
  - cloudflared
  - ngrok
  - bat config
  - and more from previous Brewfile
- packages
  - pyenv
  - pnpm
- mac
  - trash-cli
  - OS defaults
  - karabiner
  - yabai
  - skhd
  - homebrew casks
- functions
  - kill process on port with signal
- refactoring
  - clean up custom install scripts
- optimisations
  - parallelise package install scripts
- UX
  - nicer logs
  - interactive installer (choose packages)
- robustness
  - symlink home/ ?
  - clean up deleted `source-<number>/` files
