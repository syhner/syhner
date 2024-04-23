#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source/0-functions.sh"

package_name="fnm"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v $package_name" "install_package unzip && curl -fsSL https://fnm.vercel.app/install | bash"
  corepack enable pnpm
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
  install_package "pnpm"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "Schniz.fnm"
  install_package "pnpm.pnpm"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
elif [[ "$OSTYPE" == "msys" ]]; then
  export PNPM_HOME="$HOME/AppData/Local/pnpm"
fi
export PATH="$PNPM_HOME:$PATH"

pnpm add -g tldr
