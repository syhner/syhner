#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/source/0-functions.sh"

echo "Running generators"
find "$DOTFILES/generators" -name 'generate.sh' -type f | while read -r script; do
  dir_name="$(dirname -- "$script")"
  echo "Running script: $script"
  (cd "$dir_name" && . "$script")
done
echo "Finished running generators"
