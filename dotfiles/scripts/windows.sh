#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

if [[ "$OSTYPE" != "msys"* ]]; then
  return
fi

echo "Setting windows"

Set-Alias paste Get-Clipboard

echo "Finished setting windows "
