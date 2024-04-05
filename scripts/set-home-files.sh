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

  local source_file
  local target_file
  local file_path_relative

  if [[ $file_path == *".reference" ]]; then
    source_file=$(cat "$file_path")
  else
    source_file="$file_path"
  fi

  if [[ ! -f "$source_file" ]]; then
    echo "File $source_file does not exist"
    if [[ $source_file != "$file_path" ]]; then
      echo "Original source file: \"$file_path\""
    fi
    exit 1
  fi

  # Remove the $DOTFILES_HOME prefix
  target_file=${file_path#"$DOTFILES_HOME/"}
  # Remove the (<OS>) prefix
  target_file=${target_file#*(*)/}
  # Remove the .reference suffix
  target_file=${target_file%.reference}
  file_path_relative=$target_file
  # Add the $HOME prefix
  target_file="$HOME/$target_file"

  if [[ -f "$target_file" ]]; then
    if diff -q "$source_file" "$target_file" >/dev/null; then
      true # File is up to date
    else
      echo "Out of date: $file_path_relative"
      unix_timestamp="$(date +%s)"
      mkcp "$target_file" "$DOTFILES/backups/$file_path_relative-$unix_timestamp.bak"
      echo "Backup created: $DOTFILES/backups/$file_path_relative-$unix_timestamp.bak"
      cp -f "$source_file" "$target_file"
      echo "Replaced file: $target_file"
    fi
  else
    echo "Does not exist: $file_path_relative"
    mkcp "$source_file" "$target_file"
    echo "Created file: $target_file"
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

  if $skip; then
    continue
  fi

  if [[ $home_file == *"home/(linux)"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]] && [[ "$OSTYPE" != "cygwin"* ]]; then
    continue
  elif [[ $home_file == *"home/(mac)"* ]] && [[ "$OSTYPE" != "darwin"* ]]; then
    continue
  elif [[ $home_file == *"home/(windows)"* ]] && [[ "$OSTYPE" != "msys" ]]; then
    continue
  fi

  copy_home_file "$home_file"
done
echo "Finished copying files from $DOTFILES_HOME to $HOME"
