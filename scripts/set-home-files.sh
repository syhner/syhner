#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
source "$DOTFILES/home/source-0/functions.sh"

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <push|pull>"
  exit 1
fi

strategy=$1

if [[ "$strategy" != "push" && "$strategy" != "pull" ]]; then
  echo "Strategy must be 'push' or 'pull'"
  exit 1
fi

unix_timestamp="$(date +%s)"

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

  # Remove the $DOTFILES/home prefix
  target_file=${file_path#"$DOTFILES/home/"}
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
    elif [[ $strategy == "push" ]]; then
      echo "Out of date: $file_path_relative"
      mkcp "$target_file" "$DOTFILES/backups/$unix_timestamp/$file_path_relative"
      echo "Backup created: $DOTFILES/backups/$unix_timestamp/$file_path_relative"
      cp -f "$source_file" "$target_file"
      echo "Replaced file: $target_file"
    elif [[ $strategy == "pull" ]]; then
      echo "Out of date: $file_path_relative"
      mkcp "$source_file" "$DOTFILES/backups/$unix_timestamp/$file_path_relative"
      echo "Backup created: $DOTFILES/backups/$unix_timestamp/$file_path_relative"
      cp -f "$target_file" "$source_file"
      echo "Replaced file: $source_file"
    fi
  else
    echo "Does not exist: $file_path_relative"
    mkcp "$source_file" "$target_file"
    echo "Created file: $target_file"
  fi
}

ignore_filenames=(.DS_Store)
echo "Copying files from $DOTFILES/home to $HOME"
find "$DOTFILES/home" -type f | while read -r home_file; do
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
echo "Finished copying files from $DOTFILES/home to $HOME"
