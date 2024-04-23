#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source/0-functions.sh"

package_name="fzf"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v fzf" "git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/repos/fzf"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package junegunn.fzf
fi

install_package "[[ -f $HOME/repos/fzf-git/fzf-git.sh ]]" "git clone --depth=1 https://github.com/junegunn/fzf-git.sh.git $HOME/repos/fzf-git"
