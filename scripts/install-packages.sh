#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source/0-functions.sh"

echo "Installing packages"
mkdir -p "$HOME/repos"
find "$DOTFILES/scripts/install" -name '*.sh' -type f | while read -r script; do
  echo "Running script: $(basename -- "$script")"
