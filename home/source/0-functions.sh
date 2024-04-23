#!/usr/bin/env bash

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

function install_package() {
  local package_name
  local check_installed_command
  local install_command

  if [[ "$#" -eq 1 ]]; then
    package_name="$1"

    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
      if dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -q "installed"; then
        echo "$package_name is already installed with apt"
      else
        echo "Installing $package_name with package manager"
        sudo apt install --yes "$package_name"
      fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      if brew list "$package_name" &>/dev/null; then
        echo "$package_name is already installed with Homebrew."
      else
        echo "Installing $package_name with package manager"
        brew install "$package_name"
      fi

    elif [[ "$OSTYPE" == "msys" ]]; then
      if winget list --id "$package_name" &>/dev/null; then
        echo "$package_name is already installed with winget."
      else
        echo "Installing $package_name with package manager"
        winget install "--id=$package_name" --exact --accept-source-agreements --accept-package-agreements
      fi
    fi
  elif [[ "$#" -eq 2 ]]; then
    check_installed_command="$1"
    install_command="$2"

    if eval "$check_installed_command" &>/dev/null; then
      echo "Package is already installed"
    else
      echo "Installing package"
      eval "$install_command"
    fi

  else
    echo "Usage: install_package <package_name>"
    echo "Usage: install_package <check_installed_command> <install_command>"
    exit 1
  fi
}

function current_shell() {
  if [[ -n "$BASH" ]]; then
    echo 'bash'
  elif [[ -n "$ZSH_NAME" ]]; then
    echo 'zsh'
  fi
}

function source_if_exists() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: source_if_exists <file>"
    exit 1
  fi

  local file="$1"

  if [[ -f "$1" ]]; then
    source "$file"
  fi
}

function source_home() {
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: source_home <file extension>"
    exit 1
  fi

  local file_extension="$1"

  # Globs that don't match anything should be silent
  if [[ $(current_shell) == "bash" ]]; then
    shopt -s nullglob
  elif [[ $(current_shell) == "zsh" ]]; then
    setopt NULL_GLOB
  fi

  for file in "$HOME/source/"*."$file_extension"; do
    source_if_exists "$file"
  done

  if [[ $(current_shell) == "bash" ]]; then
    shopt -u nullglob
  elif [[ $(current_shell) == "zsh" ]]; then
    unsetopt NULL_GLOB
  fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  function reset_permissions() {
    if [[ "$#" -lt 1 ]]; then
      echo "Usage: reset_permissions <path_to_application>"
      exit 1
    fi

    local path_to_application="$1"

    mdls "$path_to_application" | grep kMDItemCF | awk -F'"' '{print $2}' | xargs tccutil reset All
  }
fi

function myip() {
  if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    hostname -I | awk '{print $1}'
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ipconfig getifaddr en0
  elif [[ $OSTYPE == "msys" ]]; then
    ipconfig | grep -im1 'IPv4 Address' | cut -d ':' -f2 | cut -d ' ' -f2
  fi
}
