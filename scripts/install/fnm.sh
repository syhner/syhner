#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"
source "$DOTFILES_HOME/source-0/functions.sh"

package_name="fnm"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v $package_name" "curl -fsSL https://fnm.vercel.app/install | bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "Schniz.fnm"
fi

if [ -d "$HOME/.fnm" ]; then
  export PATH="$HOME/.fnm:$PATH"
elif [ -n "$XDG_DATA_HOME" ]; then
  export PATH="$XDG_DATA_HOME/fnm:$PATH"
else
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

corepack enable pnpm
