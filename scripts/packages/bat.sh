#!/usr/bin/env bash

package_name="bat"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "bat"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "bat"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "sharkdp.bat"
fi
