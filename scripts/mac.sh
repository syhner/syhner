#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source/0-functions.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
  return
fi

# TODO - handle these brew installs better
brew install awscli 
brew install cloudflared
brew install btop 
brew install gh
brew install neofetch 

# TODO - handle these brew cask installs better
brew install cask awscli
brew install cask loudflared
brew install cask btop
brew install cask gh
brew install cask neofetch  

echo "Setting mac defaults"

defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
killall PowerChime

defaults write com.apple.dock appswitcher-all-displays -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock

# Set Desktop as the default location for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "Finished setting mac defaults"
