#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"
source "$DOTFILES_HOME/source-0/functions.sh"

package_name="nerd-fonts"

if [[ -d "$HOME/nerd-fonts" ]]; then
  echo "$package_name is already installed"
else
  echo "Installing $package_name"
  mkdir -p "$HOME/.local/share/fonts"
  git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git "$HOME/nerd-fonts"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  mkdir -p "$HOME/.local/share/fonts"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p "$HOME/Library/Fonts"
elif [[ "$OSTYPE" == "msys" ]]; then
  mkdir -p "$HOME/../../Fonts"
fi

# Relative paths in https://github.com/ryanoasis/nerd-fonts
fonts=("src/unpatched-fonts/GeistMono")

for font in "${fonts[@]}"; do
  if [[ -d "$HOME/nerd-fonts/$font" ]]; then
    echo "Font $font is already installed"
  else
    echo "Installing font $font"
    cd "$HOME/nerd-fonts" && git sparse-checkout add "$font"

    for file in "$HOME/nerd-fonts/$font/"*."otf"; do
      if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
        cp "$file" "$HOME/.local/share/fonts"
      elif [[ "$OSTYPE" == "darwin"* ]]; then
        cp "$file" "$HOME/Library/Fonts"
      elif [[ "$OSTYPE" == "msys" ]]; then
        cp "$file" "$HOME/../../Fonts"
      fi
    done
  fi
done
