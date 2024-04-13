#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source-0/functions.sh"

package_name="fnm"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "command -v $package_name" "install_package unzip && curl -fsSL https://fnm.vercel.app/install | bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
  install_package "corepack"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "Schniz.fnm"
fi

corepack enable pnpm
