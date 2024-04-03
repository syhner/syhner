#!/usr/bin/env bash

package_name="zsh-history-substring-search"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  if [[ ! -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
