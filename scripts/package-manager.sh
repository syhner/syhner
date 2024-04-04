#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  echo "Checking for package manager: apt"
  if command -v apt >/dev/null; then
    echo "Package manager is installed, updating package manager"
    sudo apt update
    echo "Finished updating package manager"
  else
    echo "Package manager is not installed, please install manually"
    exit 1
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Checking for package manager: brew"
  if command -v brew >/dev/null; then
    echo "Package manager is installed, updating package manager"
    brew update
    echo "Finished updating package manager"
  else
    echo "Package manager is not installed, installing now"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Finished installing package manager"
  fi

elif [[ "$OSTYPE" == "msys" ]]; then
  echo "Checking for package manager: winget"
  if command -v winget >/dev/null; then
    echo "Package manager is installed"
  else
    echo "Package manager is not installed, please install manually"
    exit 1
  fi
else
  echo "Unsupported OSTYPE: $OSTYPE"
  exit 1
fi
