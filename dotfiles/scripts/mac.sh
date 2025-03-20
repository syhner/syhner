#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
  return
fi

# TODO - handle these brew installs better
brew install awscli
brew install awsume
brew install btop
brew install cloudflared
brew install deskflow/homebrew-tap/deskflow
brew install fswatch
brew install gh
brew install gnupg
brew install httpie
brew install jesseduffield/lazygit/lazygit
brew install luarocks
brew install mkcert
mkcert -install
brew install neofetch
brew install ngrok/ngrok/ngrok
brew install sst/tap/sst
brew install tree
brew install watchman

# TODO - handle these brew cask installs better
brew install cask discord
# install homerow.app and change keybindings to karabiner usage
brew install cask karabiner-elements
brew install cask linear-linear
brew install cask mechvibes
brew install cask monitorcontrol
brew install cask obsidian
brew install cask orbstack
brew install cask protonvpn
brew install cask proxyman
brew install cask qbittorrent
brew install cask raycast
brew install cask scroll-reverser
brew install cask setapp
brew install cask slack
brew install cask spotify
brew install cask steam
brew install cask tailscale
brew install cask tableplus
brew install cask teamviewer
brew install cask vlc
brew install cask vmware-fusion
brew install cask yaak
brew install cask zed

# mac apps
# ghostery
# raindrop

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

# Move windows by dragging anywhere while holding ctrl and cmd
defaults write -g NSWindowShouldDragOnGesture -bool true

echo "Finished setting mac defaults"
