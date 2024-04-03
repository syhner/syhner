#!/usr/bin/env bash

package_name="fzf"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  if [[ ! -f "$HOME/.fzf/install" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "./$HOME/.fzf/install" --completion --key-bindings --no-update-rc
    no-update-rc
  fi
fi
