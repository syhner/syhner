#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

package_name="visual-studio-code"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  true # Don't install
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package Microsoft.VisualStudioCode
fi

if ! command -v code &>/dev/null; then
  return
fi

echo 'Finished installing Visual Studio Code extensions.'
