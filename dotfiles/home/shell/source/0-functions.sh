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

function mkcd() {
  mkdir -p "$1"
  cd "$1" || exit
}

function myip() {
  if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    hostname -I | awk '{print $1}'
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ipconfig getifaddr en0
  elif [[ $OSTYPE == "msys" ]]; then
    ipconfig | grep -im1 'IPv4 Address' | cut -d ':' -f2 | cut -d ' ' -f2
  fi
}

function get_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    echo "linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "mac"
  elif [[ "$OSTYPE" == "msys" ]]; then
    echo "windows"
  fi

}

# quickly jump to workspace in a monorepo
function workspace() {
  # take in a single input arg
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: workspace <workspace_name>"
    return
  fi

  cd "$(git rev-parse --show-toplevel || echo .)" || return

  # [ modules/*, packages/* ]
  jq -r '.workspaces' package.json | cut -d\" -f2 | cut -d/ -f1 | while read -r workspace; do
    if [[ -d "$workspace/$1" ]]; then
      cd "$workspace/$1" || return
    fi
  done
}
alias ws="workspace"
