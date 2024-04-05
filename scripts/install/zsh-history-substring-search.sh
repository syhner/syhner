#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source-0/functions.sh"

package_name="zsh-history-substring-search"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "[[ -f $HOME/zsh-history-substring-search/zsh-history-substring-search.zsh ]]" "git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git $HOME/zsh-history-substring-search"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
