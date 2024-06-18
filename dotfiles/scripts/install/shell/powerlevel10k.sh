#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

package_name="powerlevel10k"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "[[ -f $HOME/repos/powerlevel10k/powerlevel10k.zsh-theme ]]" "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/repos/powerlevel10k"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "[[ -f $HOME/repos/powerlevel10k/powerlevel10k.zsh-theme ]]" "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/repos/powerlevel10k"
fi
