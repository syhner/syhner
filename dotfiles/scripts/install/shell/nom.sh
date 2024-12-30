#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

package_name="nom"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v fzf" "git clone --depth 1 https://github.com/guyfedwards/nom.git $HOME/repos/nom"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "command -v fzf" "git clone --depth 1 https://github.com/guyfedwards/nom.git $HOME/repos/nom"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "command -v fzf" "git clone --depth 1 https://github.com/guyfedwards/nom.git $HOME/repos/nom"
fi

# TODO - check go installation
cd "$HOME/repos/nom"
make
