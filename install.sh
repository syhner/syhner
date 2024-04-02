#!/usr/bin/env bash
set -euo pipefail # strict mode

DOTFILES=$(dirname -- "$(readlink -f -- "$0")")
export DOTFILES
export DOTFILES_HOME="$DOTFILES/home"

source "$DOTFILES/home/util/functions.sh"

function copy_home_file() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: copy_home_file <file_path>"
    exit 1
  fi

  local file_path="$1"
  local file_path_relative
  file_path_relative="${file_path#"home/"}"

  if [[ ! -f "$file_path" ]]; then
    echo "File $file_path does not exist in dotfiles"
    exit 1
  fi

  if [[ -f "$HOME/$file_path_relative" ]]; then
    if ! diff -q "$HOME/$file_path_relative" "$file_path" >/dev/null; then
      # File exists in home directory and is different to file in dotfiles so create a backup
      unix_timestamp="$(date +%s)"
      mkcp "$HOME/$file_path_relative" "$DOTFILES/backups/$file_path_relative-$unix_timestamp.bak"
      # Replace file in home directory
      cp -f "$file_path" "$HOME/$file_path_relative"
    fi
  else
    # File does not exist so create it
    mkcp "$file_path" "$HOME/$file_path_relative"
  fi
}

ignore_files=(.DS_Store)
echo "Copying files from $DOTFILES_HOME to $HOME"
find "home" -type f | while read -r home_file; do
  skip=false
  for ignore_file in "${ignore_files[@]}"; do
    if [[ $home_file == "home/$ignore_file" ]]; then
      skip=true
    fi
  done
  if ! $skip; then
    copy_home_file "$home_file"
  fi
done
echo "Finished copying files from $DOTFILES_HOME to $HOME"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  echo "Operating system is $OSTYPE" # Linux or WSL
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
  echo 'Operating system is darwin' # macOS
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
  echo "Operating system: Windows" # Windows
  echo "Checking for package manager: winget"
  if command -v winget >/dev/null; then
    echo "Package manager is installed, updating package manager"
    winget upgrade --accept-source-agreements --accept-package-agreements
    echo "Finished updating package manager"
  else
    echo "Package manager is not installed, please install manually"
    exit 1
  fi
else
  echo "Unsupported OSTYPE: $OSTYPE"
  exit 1
fi

echo "Installing packages"
find "./packages-install" -name '*.sh' -type f | while read -r script; do
  echo "Running script: $script"
  . "$script"
done
echo "Finished installing packages"
