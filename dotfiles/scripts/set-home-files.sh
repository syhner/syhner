#!/usr/bin/env bash
set -euo pipefail # strict mode

export DOTFILES
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)/dotfiles"
source "$DOTFILES/home/source/0-functions.sh"

if [[ "$#" -lt 1 ]] || [[ "$#" -gt 2 ]]; then
  echo "Usage: $0 <push> [to = $HOME]"
  echo "       $0 <pull> [from = $HOME]"
  exit 1
fi

strategy=$1
directory=${2:-$HOME}

if [[ "$strategy" != "push" && "$strategy" != "pull" ]]; then
  echo "Strategy must be 'push' or 'pull'"
  exit 1
fi

unix_timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

function copy_home_file() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: copy_home_file <file_path>"
    exit 1
  fi

  local file_path="$1"

  local file_dot
  local file_non_dot
  local file_path_relative
  local file_source
  local file_target

  if [[ $file_path == *".reference" ]]; then
    file_dot=$(cat "$file_path")
  else
    file_dot="$file_path"
  fi

  if [[ ! -f "$file_dot" ]]; then
    if [[ $file_dot == "encrypted/"* ]]; then
      echo "Encrypted file $file_dot missing, skipping"
      return
    fi
    echo "File $file_dot does not exist in dotfiles repository"
    if [[ $file_dot != "$file_path" ]]; then
      echo "Using reference from: \"$file_path\""
    fi
    exit 1
  fi

  # Remove the $DOTFILES/home prefix
  file_non_dot=${file_path#"$DOTFILES/home/"}
  # Remove the (<OS>) prefix
  file_non_dot=${file_non_dot#*(*)/}
  # Remove the .reference suffix
  file_non_dot=${file_non_dot%.reference}
  file_path_relative=$file_non_dot
  file_non_dot="$directory/$file_non_dot"

  if [[ $strategy == "push" ]]; then
    file_source="$file_dot"
    file_target="$file_non_dot"
  elif [[ $strategy == "pull" ]]; then
    file_source="$file_non_dot"
    file_target="$file_dot"
  fi

  if [[ ! -f "$file_source" ]]; then
    return
  fi

  if [[ -f "$file_target" ]]; then
    if diff -q "$file_source" "$file_target" >/dev/null; then
      true # File is up to date
    else
      echo "Out of date: $file_path_relative"
      mkcp "$file_target" "$DOTFILES/backups/$unix_timestamp/$file_path_relative"
      echo "Backup created: $DOTFILES/backups/$unix_timestamp/$file_path_relative"
      cp -f "$file_source" "$file_target"
      echo "Replaced file: $file_target"
    fi
  else
    echo "Does not exist: $file_path_relative"
    mkcp "$file_source" "$file_target"
    echo "Created file: $file_target"
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
