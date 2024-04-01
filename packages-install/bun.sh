#!/usr/bin/env bash

package_name="bun"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  if command -v bun >/dev/null; then
    echo "$package_name is already installed"
  else
    echo "Installing $package_name with custom install command"
    install_package "unzip"
    curl -fsSL https://bun.sh/install | bash
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "oven-sh/bun/bun"
elif [[ "$OSTYPE" == "msys" ]]; then
  if command -v bun >/dev/null; then
    echo "$package_name is already installed"
  else
    echo "Installing $package_name with custom install command"
    powershell -c "irm bun.sh/install.ps1|iex"
  fi
fi
