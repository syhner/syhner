#!/usr/bin/env bash

package_name="zsh-history-substring-search"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  if [[ ! -f "$HOME/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git "$HOME/zsh-history-substring-search"
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
