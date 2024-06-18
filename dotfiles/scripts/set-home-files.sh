#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

function home_stow() {
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: home_stow <package>"
    exit 1
  fi

  local package="$1"

  if [ -f "$package/target.json" ]; then
    target="$(jq <"$package/target.json" -r ."$(get_os)" | sed "s|~|$HOME|")"
    # if a target is not speicified for the OS, skip
    if [[ "$target" == "null" ]]; then
      return
    fi
    mkdir -p "$target"
    stow --ignore target.json --target="$target" "$package"
  else
    stow --target="$HOME" "$package"
  fi
}

package=${1:-}

cd "$DOTFILES"/home

if [[ -n "$package" ]]; then
  if [[ ! -d "$package" ]]; then
    echo "$DOTFILES/home/shell/$package does not exist"
    exit 1
  fi

  home_stow "$package"
  exit 0
fi

for dir in *; do
  home_stow "$dir"
done
