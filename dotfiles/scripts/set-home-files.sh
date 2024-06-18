#!/usr/bin/env bash
set -euo pipefail # strict mode

# TODO: needs cleaning up

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

package=${1:-}

cd "$DOTFILES"/home

if [[ -n "$package" ]]; then
  echo "Copying files for package $package/home/$package"
  if [[ ! -d "$package" ]]; then
    echo "$DOTFILES/home/$package does not exist"
    exit 1
  fi

  if [ -f "$package/target.json" ]; then
    target="$(jq <"$package/target.json" -r ."$(get_os)" | sed "s|~|$HOME|")"
    # if a target is not speicified for the OS, skip
    if [[ "$target" == "null" ]]; then
      exit 0
    fi
    mkdir -p "$target"
    stow --ignore target.json --target="$target" "$package"
  else
    echo 'hi'
    stow --target="$HOME" "$package"
  fi

  exit 0
fi

for dir in *; do
  if [ -f "$dir/target.json" ]; then
    target="$(jq <"$dir/target.json" -r ."$(get_os)" | sed "s|~|$HOME|")"
    # if a target is not speicified for the OS, skip
    if [[ "$target" == "null" ]]; then
      continue
    fi
    mkdir -p "$target"
    stow --ignore target.json --target="$target" "$dir"
  else
    echo 'hi'
    stow --target="$HOME" "$dir"
  fi
done
