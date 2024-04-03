#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
export DOTFILES_HOME="$DOTFILES/home"

source "$DOTFILES_HOME/source-0/functions.sh"

function copy_home_file() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: copy_home_file <file_path>"
    exit 1
  fi

  local file_path="$1"
  local file_path_relative
  file_path_relative="${file_path#*"home/"}"

  if [[ ! -f "$file_path" ]]; then
    echo "File $file_path does not exist in dotfiles"
    exit 1
  fi

  if [[ -f "$HOME/$file_path_relative" ]]; then
    if diff -q "$HOME/$file_path_relative" "$file_path" >/dev/null; then
      echo "Up to date: $HOME/$file_path_relative"
    else
      unix_timestamp="$(date +%s)"
      mkcp "$HOME/$file_path_relative" "$DOTFILES/backups/$file_path_relative-$unix_timestamp.bak"
      echo "Out of date: $HOME/$file_path_relative"
      echo "Backup created: $DOTFILES/backups/$file_path_relative-$unix_timestamp.bak"
      # Replace file in home directory
      cp -f "$file_path" "$HOME/$file_path_relative"
      echo "Replaced file: $HOME/$file_path_relative"
    fi
  else
    # File does not exist so create it
    echo "Does not exist: $HOME/$file_path_relative"
    mkcp "$file_path" "$HOME/$file_path_relative"
    echo "Created file: $HOME/$file_path_relative"
  fi
}

ignore_filenames=(.DS_Store)
echo "Copying files from $DOTFILES_HOME to $HOME"
find "$DOTFILES_HOME" -type f | while read -r home_file; do
  skip=false
  for ignore_file in "${ignore_filenames[@]}"; do
    filename=$(basename -- "$home_file")
    if [[ $filename == "$ignore_file" ]]; then
      skip=true
    fi
  done
  if ! $skip; then
    copy_home_file "$home_file"
  fi
done
echo "Finished copying files from $DOTFILES_HOME to $HOME"
