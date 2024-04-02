#!/usr/bin/env bash

package_name="<package_name>"

echo "Checking for $package_name installation"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_package "$package_name"
elif [[ "$OSTYPE" == "msys" ]]; then
  install_package "$package_name"
fi
