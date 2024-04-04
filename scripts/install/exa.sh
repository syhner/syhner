#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"
source "$DOTFILES_HOME/source-0/functions.sh"

package_name="exa"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  return # TODO
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # Not yet supported
fi
