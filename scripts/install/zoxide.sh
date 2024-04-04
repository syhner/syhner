#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"
source "$DOTFILES_HOME/source-0/functions.sh"

package_name="zoxide"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v zoxide" "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "ajeetdsouza.zoxide"
fi
