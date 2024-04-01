#!/usr/bin/env bash
set -euo pipefail # strict mode

DOTFILES=$(dirname -- "$(readlink -f -- "$0")")
export DOTFILES
export DOTFILES_HOME="$DOTFILES/home"

function mkcp() {
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: mkcp <source> <destination>"
    exit 1
  fi

  local source="$1"
  local destination="$2"
  local dir_to_create
  dir_to_create="$(dirname -- "$destination")"

  [[ ! -e $dir_to_create ]] && mkdir -p "$dir_to_create"
  cp "$source" "$destination"
}

function copy_home_file() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: copy_home_file <file_path>"
    exit 1
  fi

  local file_path="$1"
  local file_path_relative
  file_path_relative="${file_path#"home/"}"
  local dir_to_create

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
