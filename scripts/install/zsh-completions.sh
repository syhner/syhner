#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source-0/functions.sh"

package_name="zsh-completions"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "[[ -f $HOME/zsh-completions/zsh-completions.plugin.zsh ]]" "git clone https://github.com/zsh-users/zsh-completions.git $HOME/zsh-completions"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
