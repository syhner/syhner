#!/usr/bin/env bash

package_name="fnm"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  if command -v fnm >/dev/null; then
    echo "$package_name is already installed"
  else
    echo "Installing $package_name with custom install command"
    curl -fsSL https://fnm.vercel.app/install | bash
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "fnm"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "Schniz.fnm"
fi

fnm install --lts
