#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"

. "$DOTFILES/scripts/add-git-hooks.sh"
. "$DOTFILES/scripts/package-manager.sh"
. "$DOTFILES/scripts/install-packages.sh"
. "$DOTFILES/scripts/mac-defaults.sh"
. "$DOTFILES/scripts/stow.sh"
