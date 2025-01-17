# install v1.93 manually for compat with apc customise ui++

# #!/usr/bin/env bash
# set -euo pipefail # strict mode

# export DOTFILES
# DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
# source "$DOTFILES/home/shell/source/0-functions.sh"

# package_name="visual-studio-code"

# if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
#   true # Don't install
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#   install_package "$package_name"
#   defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# elif [[ "$OSTYPE" == "msys" ]]; then
#   install_package Microsoft.VisualStudioCode
# fi

# if ! command -v code &>/dev/null; then
#   return
# fi

# echo 'Installing Visual Studio Code extensions...'

# # Used in settings / keybindings
# code --install-extension antfu.where-am-i
# code --install-extension akil-s.tokyo-light
# code --install-extension drcika.apc-extension
# code --install-extension enkia.tokyo-night
# code --install-extension hoovercj.vscode-settings-cycler
# code --install-extension PKief.material-icon-theme
# code --install-extension ryuta46.multi-command
# code --install-extension timonwong.shellcheck
# code --install-extension TomRijndorp.find-it-faster
# code --install-extension usernamehw.errorlens
# code --install-extension vscodevim.vim

# # Not used in settings / keybindings, improves DX, language agnostic
# code --install-extension aaron-bond.better-comments
# code --install-extension adpyke.codesnap
# code --install-extension beatzoid.http-status-codes
# code --install-extension EditorConfig.EditorConfig
# code --install-extension mikestead.dotenv
# code --install-extension timonwong.shellcheck

# echo 'Finished installing Visual Studio Code extensions.'
