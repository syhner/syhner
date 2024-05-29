#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source/0-functions.sh"

echo "chmod +x $DOTFILES/scripts/**/*.sh" >"$DOTFILES/.git/hooks/pre-commit"
chmod +x "$DOTFILES/.git/hooks/pre-commit"
