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
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: install_package <package_name> [install_command]"
    exit 1
  fi

  local package_name="$1"
  local install_command="${2:-""}"

  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    if dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -q "installed"; then
      echo "$package_name is already installed with apt"
    elif [[ "$install_command" == "" ]]; then
      echo "Installing $package_name with package manager"
      sudo apt install --yes "$package_name"
    else
      echo "Installing $package_name with custom install command"
      eval "$install_command"
    fi

  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if brew list "$package_name" &>/dev/null; then
      echo "$package_name is already installed with Homebrew."
    elif [[ "$install_command" == "" ]]; then
      echo "Installing $package_name with package manager"
      brew install "$package_name"
    else
      echo "Installing $package_name with custom install command"
      eval "$install_command"
    fi

  elif [[ "$OSTYPE" == "msys" ]]; then
    if winget list --id "$package_name" &>/dev/null; then
      echo "$package_name is already installed with winget."
    elif [[ "$install_command" == "" ]]; then
      echo "Installing $package_name with package manager"
      winget install "--id=$package_name" --exact --accept-source-agreements --accept-package-agreements
    else
      echo "Installing $package_name with custom install command"
      eval "$install_command"
    fi

  else
    echo "Unsupported OSTYPE: $OSTYPE"
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

  local package_name="$1"

  if [[ -f "$1" ]]; then
    source "$1"
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

  for dir in "$HOME/source-"*; do
    for file in "$dir/"*."$file_extension"; do
      source_if_exists "$file"
    done
  done

  if [[ $(current_shell) == "bash" ]]; then
    shopt -u nullglob
  elif [[ $(current_shell) == "zsh" ]]; then
    unsetopt NULL_GLOB
  fi
}
