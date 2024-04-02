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
2. Check for package manager (apt for Linux / WSL, Homebrew for macOS, winget for Windows).
3. Run package install scripts in [`scripts/packages/`](scripts/packages/) using the right package manager
