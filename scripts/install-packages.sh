#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"

source "$DOTFILES_HOME/source-0/functions.sh"

echo "Installing packages"
find "$DOTFILES/scripts/install" -name '*.sh' -type f | while read -r script; do
  echo "Running script: $script"
  . "$script"
done
echo "Finished installing packages"
