#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source-0/functions.sh"

package_name="zsh-you-should-use"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "[[ -f $HOME/zsh-you-should-use/you-should-use.plugin.zsh ]]" "git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git $HOME/zsh-you-should-use"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
