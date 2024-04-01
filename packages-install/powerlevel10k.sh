#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  if [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
  fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "powerlevel10k"

elif [[ "$OSTYPE" == "msys" ]]; then
  if [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
  fi
fi
