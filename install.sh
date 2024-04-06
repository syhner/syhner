#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"

. "$DOTFILES/scripts/add-git-hooks.sh"
. "$DOTFILES/scripts/set-home-files.sh"
. "$DOTFILES/scripts/package-manager.sh"
. "$DOTFILES/scripts/install-packages.sh"
