#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/shell/source/0-functions.sh"

package_name="nerd-fonts"

if [[ -d "$HOME/repos/nerd-fonts" ]]; then
  echo "$package_name is already installed"
else
  echo "Installing $package_name"
  mkdir -p "$HOME/.local/share/fonts"
  git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git "$HOME/repos/nerd-fonts"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  mkdir -p "$HOME/.local/share/fonts"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p "$HOME/Library/Fonts"
elif [[ "$OSTYPE" == "msys" ]]; then
  mkdir -p "$HOME/../../Fonts"
fi

# Relative paths in https://github.com/ryanoasis/nerd-fonts
fonts=("src/unpatched-fonts/GeistMono" "patched-fonts/CascadiaCode")

for font in "${fonts[@]}"; do
  if [[ -d "$HOME/repos/nerd-fonts/$font" ]]; then
    echo "Font $font is already installed"
  else
    echo "Installing font $font"
    cd "$HOME/repos/nerd-fonts" && git sparse-checkout add "$font"

    # Globs that don't match anything should be silent
    if [[ $(current_shell) == "bash" ]]; then
      shopt -s nullglob
    elif [[ $(current_shell) == "zsh" ]]; then
      setopt NULL_GLOB
    fi

    for file in "$HOME/repos/nerd-fonts/$font/"**/*.{otf,ttf}; do
      if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
        cp "$file" "$HOME/.local/share/fonts"
      elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Copying $file to $HOME/Library/Fonts"
        cp "$file" "$HOME/Library/Fonts"
      elif [[ "$OSTYPE" == "msys" ]]; then
        cp "$file" "$HOME/../../Fonts"
      fi
    done

    if [[ $(current_shell) == "bash" ]]; then
      shopt -u nullglob
    elif [[ $(current_shell) == "zsh" ]]; then
      unsetopt NULL_GLOB
    fi

  fi
done
